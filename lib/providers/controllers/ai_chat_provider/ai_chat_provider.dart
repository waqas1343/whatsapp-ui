import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final List<Map<String, String>> _messages = [];
  String? _lastMedicineQueried;
  int? _lastRequestedQuantity;

  List<Map<String, String>> get messages => List.unmodifiable(_messages);

  Future<void> sendMessage(String message) async {
    _addMessage("user", message);
    String lowerMessage = message.toLowerCase().trim();

    print("User Message: $lowerMessage");

    if (lowerMessage == "medicine") {
      await _showAvailableMedicines();
      return;
    }

    if (await _handleMedicineSelection(lowerMessage)) {
      return;
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
      }
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
    }
    return null;
  }

  Future<double> _calculateTotalPrice(String medicineName, int quantity) async {
    var querySnapshot =
        await FirebaseFirestore.instance
            .collection("products")
            .where("name", isEqualTo: medicineName)
            .limit(1)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      double price = querySnapshot.docs.first["price"] ?? 0;
      return price * quantity;
    }
    return 0;
  }

  Future<void> _placeOrder(String medicineName, int quantity) async {
    var querySnapshot =
        await FirebaseFirestore.instance
            .collection("products")
            .where("name", isEqualTo: medicineName)
            .limit(1)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      int stock = doc["stock"] ?? 0;

      if (stock >= quantity) {
        await FirebaseFirestore.instance.collection("orders").add({
          "medicine": medicineName,
          "quantity": quantity,
          "status": "pending",
          "timestamp": FieldValue.serverTimestamp(),
        });

        await FirebaseFirestore.instance
            .collection("products")
            .doc(doc.id)
            .update({"stock": stock - quantity});

        _addMessage(
          "bot",
          "✅ Aapka order '$medicineName' ($quantity units) ke liye place ho chuka hai!",
        );
      } else {
        _addMessage(
          "bot",
          "❌ '$medicineName' ke liye sirf $stock stock available hai. Aap kam quantity select karna chahenge?",
        );
      }
    }
  }

  void _addMessage(String role, String content) {
    _messages.add({"role": role, "content": content});
    notifyListeners();
  }
}
