import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum ChatState {
  idle,
  selectingClothing,
  selectingQuantity,
  confirmingOrder,
  selectingPayment,
}

class ClothingChatProvider extends ChangeNotifier {
  final List<Map<String, String>> _messages = [];
  ChatState _currentState = ChatState.idle;
  String? _selectedClothing;
  int? _selectedQuantity;

  List<Map<String, String>> get messages => List.unmodifiable(_messages);
  ChatState get currentState => _currentState;

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;
    _addMessage("user", message);
    String input = message.toLowerCase().trim();

    switch (_currentState) {
      case ChatState.idle:
        if (input.contains("clothing")) {
          await _showAvailableClothings();
          _currentState = ChatState.selectingClothing;
        } else {
          _addMessage(
            "bot",
            "👋 Salam! 'clothing' likh kar kapron ki list hasil karein.",
          );
        }
        break;

      case ChatState.selectingClothing:
        if (await _handleClothingSelection(input)) {
          _currentState = ChatState.selectingQuantity;
        }
        break;

      case ChatState.selectingQuantity:
        if (await _handleQuantitySelection(input)) {
          _currentState = ChatState.confirmingOrder;
        }
        break;

      case ChatState.confirmingOrder:
        if (input == "yes" || input == "haan") {
          await _askPaymentMethod();
          _currentState = ChatState.selectingPayment;
        } else {
          _addMessage("bot", "🛑 Order cancel! Phir se shuru karein.");
          _resetState();
        }
        break;

      case ChatState.selectingPayment:
        if (await _handlePaymentSelection(input)) {
          _resetState();
        }
        break;
    }
  }

  Future<void> _showAvailableClothings() async {
    List<String> clothings = await _getAllClothings();
    if (clothings.isNotEmpty) {
      String list = clothings
          .asMap()
          .entries
          .map((e) => "${e.key + 1}. ${e.value}")
          .join("\n");
      _addMessage(
        "bot",
        "👕 Mojood kapray:\n$list\nKoi aik number ya naam likhein!",
      );
    } else {
      _addMessage("bot", "😔 Koi kapra mojood nahi hai.");
    }
  }

  Future<bool> _handleClothingSelection(String input) async {
    List<String> clothings = await _getAllClothings();
    String? selected;

    if (clothings.contains(input)) {
      selected = input;
    } else if (int.tryParse(input) != null) {
      int index = int.parse(input) - 1;
      if (index >= 0 && index < clothings.length) {
        selected = clothings[index];
      }
    }

    if (selected != null) {
      _selectedClothing = selected;
      String? details = await _getClothingDetails(selected);
      if (details != null) {
        _addMessage("bot", "$details\nAap ko kitni quantity chahiye?");
        return true;
      } else {
        _addMessage("bot", "❌ '$selected' ka data nahi mila.");
      }
    } else {
      _addMessage("bot", "❓ Sahi number ya naam likhein!");
    }
    return false;
  }

  Future<bool> _handleQuantitySelection(String input) async {
    int? quantity = int.tryParse(input);
    if (quantity != null && quantity > 0) {
      _selectedQuantity = quantity;
      double totalPrice = await _calculateTotalPrice(
        _selectedClothing!,
        quantity,
      );
      _addMessage(
        "bot",
        "📦 $quantity $_selectedClothing ka total: Rs. $totalPrice\nKya aap confirm karte hain? (yes/no)",
      );
      return true;
    } else {
      _addMessage("bot", "❌ Sahi quantity likhein (e.g., 1, 2, 3)!");
      return false;
    }
  }

  Future<void> _askPaymentMethod() async {
    _addMessage(
      "bot",
      "💰 Payment ka tareeqa chunein:\n1. JazzCash\n2. EasyPaisa\n3. Banking\n(jazzcash/easypaisa/banking likhein)",
    );
  }

  Future<bool> _handlePaymentSelection(String input) async {
    if (["jazzcash", "easypaisa", "banking"].contains(input)) {
      await _placeOrder(_selectedClothing!, _selectedQuantity!, input);
      _addMessage(
        "bot",
        "🎉 Order place ho gaya! ($_selectedClothing, $_selectedQuantity via $input)",
      );
      return true;
    } else {
      _addMessage("bot", "❌ Valid payment method likhein!");
      return false;
    }
  }

  Future<List<String>> _getAllClothings() async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection("clothing").get();
      return snapshot.docs.map((doc) => doc["name"] as String).toList();
    } catch (e) {
      debugPrint("Error fetching clothings: $e");
      return [];
    }
  }

  Future<String?> _getClothingDetails(String clothingName) async {
    try {
      var snapshot =
          await FirebaseFirestore.instance
              .collection("clothing")
              .where("name", isEqualTo: clothingName)
              .limit(1)
              .get();
      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        return "👗 $clothingName:\n• Tafseel: ${doc["description"] ?? "N/A"}\n• Size: ${doc["size"] ?? "N/A"}\n• Price: Rs. ${(doc["price"] as num?)?.toDouble() ?? 0.0}\n• Stock: ${(doc["stock"] as num?)?.toInt() ?? 0}";
      }
    } catch (e) {
      debugPrint("Error fetching clothing details: $e");
    }
    return null;
  }

  Future<double> _calculateTotalPrice(String clothingName, int quantity) async {
    try {
      var snapshot =
          await FirebaseFirestore.instance
              .collection("clothing")
              .where("name", isEqualTo: clothingName)
              .limit(1)
              .get();
      if (snapshot.docs.isNotEmpty) {
        double price =
            (snapshot.docs.first["price"] as num?)?.toDouble() ?? 0.0;
        return price * quantity;
      }
    } catch (e) {
      debugPrint("Error calculating total price: $e");
    }
    return 0.0;
  }

  Future<void> _placeOrder(
    String clothingName,
    int quantity,
    String paymentMethod,
  ) async {
    await FirebaseFirestore.instance.collection("orders").add({
      "clothing": clothingName,
      "quantity": quantity,
      "paymentMethod": paymentMethod,
      "status": "pending",
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  void _addMessage(String role, String content) {
    _messages.add({"role": role, "content": content});
    notifyListeners();
  }

  void _resetState() {
    _selectedClothing = null;
    _selectedQuantity = null;
    _currentState = ChatState.idle;
  }
}
