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

  String? _lastMedicineQueried;
  int? _lastRequestedQuantity;

  ChatState _currentState = ChatState.idle;
  String? _selectedMedicine;
  int? _selectedQuantity;


  List<Map<String, String>> get messages => List.unmodifiable(_messages);
  ChatState get currentState => _currentState;

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    _addMessage("user", message);
    String input = message.toLowerCase().trim();


    print("User Message: $lowerMessage");

    if (lowerMessage == "medicine") {
      await _showAvailableMedicines();
      return;
    }

    if (await _handleMedicineSelection(lowerMessage)) {
      return;

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
        } else if (input == "no" || input == "nahi") {
          _addMessage(
            "bot",
            "🛑 Order cancel kar diya gaya. Dobara shuru karein!",
          );
          _resetState();
        } else {
          _addMessage("bot", "❓ Kripya 'yes' ya 'no' mein jawab dein.");
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
          "🩺 Ye hain available medicines:\n$list\nKripya number ya naam chunein!",
        );
      } else {
        _addMessage("bot", "😔 Abhi koi medicine available nahi hai.");
      }
    } catch (e) {
      _addMessage("bot", "⚠️ Medicines fetch karne mein problem: $e");

    }
  }


    if (_lastMedicineQueried != null && _lastRequestedQuantity == null) {
      await _handleQuantitySelection(lowerMessage);
      return;
    }

    if (_lastMedicineQueried != null &&
        _lastRequestedQuantity != null &&
        (lowerMessage == "yes" || lowerMessage == "haan")) {
      await _confirmOrder();
      return;
    }
  }

  Future<void> _showAvailableMedicines() async {
    List<String> allMedicines = await _getAllMedicines();
    if (allMedicines.isNotEmpty) {
      String formattedList = allMedicines
          .asMap()
          .entries
          .map((entry) => "${entry.key + 1}. ${entry.value}")
          .join("\n");
      _addMessage(
        "bot",
        "🩺 Available medicines:\n$formattedList\nKripya ya to number ya medicine ka naam select karein.",
      );
    } else {
      _addMessage("bot", "⚠️ Koi medicine database me available nahi hai.");
    }
  }

  Future<bool> _handleMedicineSelection(String input) async {
    List<String> allMedicines = await _getAllMedicines();
    if (allMedicines.contains(input)) {
      return await _showMedicineDetails(input);
    } else if (int.tryParse(input) != null) {
      int index = int.parse(input) - 1;
      if (index >= 0 && index < allMedicines.length) {
        return await _showMedicineDetails(allMedicines[index]);

  Future<bool> _handleMedicineSelection(String input) async {
    try {
      List<String> medicines = await _getAllMedicines();
      String? medicine;

      if (medicines.contains(input)) {
        medicine = input;
      } else if (int.tryParse(input) != null) {
        int index = int.parse(input) - 1;
        if (index >= 0 && index < medicines.length) {
          medicine = medicines[index];
        }
      }

      if (medicine != null) {
        _selectedMedicine = medicine;
        String? details = await _getMedicineDetails(medicine);
        if (details != null) {
          _addMessage("bot", "$details\nKitni quantity chahiye?");
          return true;
        } else {
          _addMessage("bot", "❌ '$medicine' ka data nahi mila.");
        }
      } else {
        _addMessage("bot", "❓ Sahi number ya naam chunein!");

      }
      return false;
    } catch (e) {
      _addMessage("bot", "⚠️ Error: $e");
      return false;
    }

    return false;
  }

  Future<bool> _showMedicineDetails(String medicineName) async {
    _lastMedicineQueried = medicineName;
    String? medicineDetails = await _getMedicineDetails(medicineName);
    if (medicineDetails != null) {
      _addMessage("bot", "$medicineDetails\nAap ki kitni quantity chahiye?");
      return true;
    }
    return false;
  }

  Future<void> _handleQuantitySelection(String input) async {
    int? quantity = int.tryParse(input);
    if (quantity != null && quantity > 0) {
      _lastRequestedQuantity = quantity;
      double totalPrice = await _calculateTotalPrice(
        _lastMedicineQueried!,
        quantity,
      );
      _addMessage(
        "bot",
        "Aapke order me $quantity items hain. Total price: Rs. $totalPrice. Kya aap confirm karna chahenge? (yes/no)",
      );
    } else {
      _addMessage("bot", "❌ Kripya ek valid quantity likhein.");
    }
  }

  Future<void> _confirmOrder() async {
    await _placeOrder(_lastMedicineQueried!, _lastRequestedQuantity!);
    _lastMedicineQueried = null;
    _lastRequestedQuantity = null;
  }

  Future<List<String>> _getAllMedicines() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection("products").get();
    return querySnapshot.docs.map((doc) => doc["name"].toString()).toList();
  }

  Future<String?> _getMedicineDetails(String medicineName) async {
    var querySnapshot =

  }

  Future<bool> _handleQuantitySelection(String input) async {
    try {
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
    } catch (e) {
      _addMessage("bot", "⚠️ Quantity process mein error: $e");
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
    try {
      if (["jazzcash", "easypaisa", "banking"].contains(input)) {
        await _placeOrder(_selectedMedicine!, _selectedQuantity!, input);
        _addMessage(
          "bot",
          "🎉 Order placed!\n'$_selectedMedicine' ($_selectedQuantity units) via $input.\nJab ready hoga, aapko inform kar denge!",
        );
        return true;
      } else {
        _addMessage("bot", "❌ JazzCash, EasyPaisa, ya Banking chunein!");
        return false;
      }
    } catch (e) {
      _addMessage("bot", "⚠️ Payment process mein error: $e");
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


    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      String description = doc["description"] ?? "No description available.";
      String dosage = doc["dosage"] ?? "No dosage information available.";
      double price = doc["price"] ?? 0.0;
      int stock = doc["stock"] ?? 0;
      return "🩺 '$medicineName' ke details:\n"
          "• Description: $description\n"
          "• Dosage: $dosage\n"
          "• Price: Rs. $price\n"
          "• Stock: $stock available";

    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first;
      return "💊 $medicineName:\n"
          "• Desc: ${doc["description"] ?? "N/A"}\n"
          "• Dosage: ${doc["dosage"] ?? "N/A"}\n"
          "• Price: Rs. ${(doc["price"] as num?)?.toDouble() ?? 0.0}\n"
          "• Stock: ${(doc["stock"] as num?)?.toInt() ?? 0}";

    }
    return null;
  }

  Future<double> _calculateTotalPrice(String medicineName, int quantity) async {

    var querySnapshot =

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


  Future<void> _placeOrder(String medicineName, int quantity) async {
    var querySnapshot =

  Future<void> _placeOrder(
    String medicineName,
    int quantity,
    String paymentMethod,
  ) async {
    var snapshot =

        await FirebaseFirestore.instance
            .collection("products")
            .where("name", isEqualTo: medicineName)
            .limit(1)
            .get();

    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first;
      int stock = (doc["stock"] as num?)?.toInt() ?? 0;

      if (stock >= quantity) {
        await FirebaseFirestore.instance.collection("orders").add({
          "medicine": medicineName,
          "quantity": quantity,
          "paymentMethod": paymentMethod,
          "status": "pending",
          "timestamp": FieldValue.serverTimestamp(),
        });
        await doc.reference.update({"stock": stock - quantity});
      } else {
        _addMessage(
          "bot",
          "⚠️ Sorry, $medicineName ka stock ($stock) kam hai!",
        );
        throw Exception("Insufficient stock");
      }


    } else {
      throw Exception("Medicine not found");

    }
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
