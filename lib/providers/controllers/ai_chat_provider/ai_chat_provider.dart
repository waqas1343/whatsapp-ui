import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum ChatState {
  idle,
  selectingMedicine,
  selectingQuantity,
  confirmingOrder,
  selectingPayment,
}

class ChatProvider extends ChangeNotifier {
  final List<Map<String, String>> _messages = [];
  ChatState _currentState = ChatState.idle;
  String? _selectedMedicine;
  int? _selectedQuantity;

  List<Map<String, String>> get messages => List.unmodifiable(_messages);
  ChatState get currentState => _currentState;

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    _addMessage("user", message);
    String input = message.toLowerCase().trim();

    print("User Input: $input | Current State: $_currentState");

    switch (_currentState) {
      case ChatState.idle:
        if (input == "medicine" || input == "medicines") {
          await _showAvailableMedicines();
          _currentState = ChatState.selectingMedicine;
        } else {
          _addMessage("bot", "👋 Namaste! 'medicine' likhkar shuru karein!");
        }
        break;

      case ChatState.selectingMedicine:
        if (await _handleMedicineSelection(input)) {
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
          _addMessage(
            "bot",
            "🛑 Order cancel kar diya gaya. Dobara shuru karein!",
          );
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

  Future<void> _showAvailableMedicines() async {
    try {
      List<String> medicines = await _getAllMedicines();
      if (medicines.isNotEmpty) {
        String list = medicines
            .asMap()
            .entries
            .map((e) => "${e.key + 1}. ${e.value}")
            .join("\n");
        _addMessage(
          "bot",
          "🩺 Available medicines:\n$list\nKripya number ya naam chunein!",
        );
      } else {
        _addMessage("bot", "😔 Koi medicine available nahi hai.");
      }
    } catch (e) {
      _addMessage("bot", "⚠️ Medicines fetch karne mein problem: $e");
    }
  }

  Future<bool> _handleMedicineSelection(String input) async {
    List<String> medicines = await _getAllMedicines();
    String? selected;

    if (medicines.contains(input)) {
      selected = input;
    } else if (int.tryParse(input) != null) {
      int index = int.parse(input) - 1;
      if (index >= 0 && index < medicines.length) {
        selected = medicines[index];
      }
    }

    if (selected != null) {
      _selectedMedicine = selected;
      String? details = await _getMedicineDetails(selected);
      if (details != null) {
        _addMessage("bot", "$details\nKitni quantity chahiye?");
        return true;
      } else {
        _addMessage("bot", "❌ '$selected' ka data nahi mila.");
      }
    } else {
      _addMessage("bot", "❓ Sahi number ya naam chunein!");
    }
    return false;
  }

  Future<bool> _handleQuantitySelection(String input) async {
    int? quantity = int.tryParse(input);
    if (quantity != null && quantity > 0) {
      _selectedQuantity = quantity;
      double totalPrice = await _calculateTotalPrice(
        _selectedMedicine!,
        quantity,
      );
      _addMessage(
        "bot",
        "📦 $quantity $_selectedMedicine ka total: Rs. $totalPrice\nConfirm karein? (yes/no)",
      );
      return true;
    } else {
      _addMessage("bot", "❌ Valid quantity daliye (e.g., 1, 2, 3)!");
      return false;
    }
  }

  Future<void> _askPaymentMethod() async {
    _addMessage(
      "bot",
      "💰 Payment ka tareeka chunein:\n1. JazzCash\n2. EasyPaisa\n3. Banking\n(jazzcash/easypaisa/banking likhein)",
    );
  }

  Future<bool> _handlePaymentSelection(String input) async {
    if (["jazzcash", "easypaisa", "banking"].contains(input)) {
      await _placeOrder(_selectedMedicine!, _selectedQuantity!, input);
      _addMessage(
        "bot",
        "🎉 Order placed successfully! ($_selectedMedicine, $_selectedQuantity units via $input)",
      );
      return true;
    } else {
      _addMessage("bot", "❌ Valid payment method choose karein!");
      return false;
    }
  }

  Future<List<String>> _getAllMedicines() async {
    var snapshot =
        await FirebaseFirestore.instance.collection("products").get();
    return snapshot.docs.map((doc) => doc["name"] as String).toList();
  }

  Future<String?> _getMedicineDetails(String medicineName) async {
    var snapshot =
        await FirebaseFirestore.instance
            .collection("products")
            .where("name", isEqualTo: medicineName)
            .limit(1)
            .get();
    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first;
      return "💊 $medicineName:\n• Description: ${doc["description"] ?? "N/A"}\n• Dosage: ${doc["dosage"] ?? "N/A"}\n• Price: Rs. ${(doc["price"] as num?)?.toDouble() ?? 0.0}\n• Stock: ${(doc["stock"] as num?)?.toInt() ?? 0}";
    }
    return null;
  }

  Future<double> _calculateTotalPrice(String medicineName, int quantity) async {
    var snapshot =
        await FirebaseFirestore.instance
            .collection("products")
            .where("name", isEqualTo: medicineName)
            .limit(1)
            .get();
    if (snapshot.docs.isNotEmpty) {
      double price = (snapshot.docs.first["price"] as num?)?.toDouble() ?? 0.0;
      return price * quantity;
    }
    return 0.0;
  }

  Future<void> _placeOrder(
    String medicineName,
    int quantity,
    String paymentMethod,
  ) async {
    await FirebaseFirestore.instance.collection("orders").add({
      "medicine": medicineName,
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
    _selectedMedicine = null;
    _selectedQuantity = null;
    _currentState = ChatState.idle;
  }
}
