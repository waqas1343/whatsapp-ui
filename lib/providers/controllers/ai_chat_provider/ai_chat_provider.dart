import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final List<Map<String, String>> _messages = [];
  String? lastMedicineQueried;
  int? lastRequestedQuantity;

  List<Map<String, String>> get messages => List.unmodifiable(_messages);

  Future<void> sendMessage(String message) async {
    _addMessage("user", message);
    String lowerMessage = message.toLowerCase().trim();

    if (lastMedicineQueried != null && lastRequestedQuantity == null) {
      int? quantity = int.tryParse(lowerMessage);
      if (quantity != null && quantity > 0) {
        lastRequestedQuantity = quantity;
        double totalPrice = await calculateTotalPrice(
          lastMedicineQueried!,
          quantity,
        );
        _addMessage(
          "bot",
          "Aapke order ka total price Rs. $totalPrice banta hai. Kya aap confirm karna chahenge? (yes/no)",
        );
        return;
      } else {
        _addMessage("bot", "Kripya ek valid quantity likhein.");
        return;
      }
    }

    if (lastMedicineQueried != null &&
        lastRequestedQuantity != null &&
        (lowerMessage == "yes" || lowerMessage == "haan")) {
      await placeOrder(lastMedicineQueried!, lastRequestedQuantity!);
      lastMedicineQueried = null;
      lastRequestedQuantity = null;
      return;
    }

    var medicinesAndCategories = await fetchMedicinesAndCategories();
    List<String> availableMedicines = medicinesAndCategories["medicines"] ?? [];
    List<String> availableCategories =
        medicinesAndCategories["categories"] ?? [];

    if (availableMedicines.contains(lowerMessage)) {
      String? medicineDetails = await getMedicineDetails(lowerMessage);
      if (medicineDetails != null) {
        lastMedicineQueried = lowerMessage;
        _addMessage(
          "bot",
          "$medicineDetails\nAap kitni quantity buy karna chahenge?",
        );
        return;
      }
    }

    if (availableCategories.contains(lowerMessage)) {
      String? categoryResponse = await checkCategoryAvailability(lowerMessage);
      if (categoryResponse != null) {
        _addMessage("bot", categoryResponse);
        return;
      }
    }

    _addMessage(
      "bot",
      "Maaf kijiye, mai sirf medical-related sawalon ka jawab de sakta hoon. Aap kis medicine ke baare me puchna chahenge?",
    );
  }

  Future<Map<String, List<String>>> fetchMedicinesAndCategories() async {
    try {
      var querySnapshot =
          await FirebaseFirestore.instance.collection("products").get();
      List<String> medicines = [];
      Set<String> categories = {};

      for (var doc in querySnapshot.docs) {
        medicines.add((doc["name"] as String).toLowerCase());
        if (doc["category"] != null) {
          categories.add((doc["category"] as String).toLowerCase());
        }
      }

      return {"medicines": medicines, "categories": categories.toList()};
    } catch (e) {
      return {"medicines": [], "categories": []};
    }
  }

  Future<String?> getMedicineDetails(String medicineName) async {
    try {
      var querySnapshot =
          await FirebaseFirestore.instance
              .collection("products")
              .where("name", isEqualTo: medicineName)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        return "\u2728 '${doc["name"]}' details:\n• Description: ${doc["description"] ?? "No description"}\n• Price: Rs. ${doc["price"] ?? 0}\n• Stock: ${doc["stock"] ?? 0} available";
      }
      return "❌ '$medicineName' store me available nahi hai.";
    } catch (e) {
      return "Error fetching medicine details.";
    }
  }

  Future<double> calculateTotalPrice(String medicineName, int quantity) async {
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

  Future<void> placeOrder(String medicineName, int quantity) async {
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

  Future<String?> checkCategoryAvailability(String categoryName) async {
    try {
      var querySnapshot =
          await FirebaseFirestore.instance
              .collection("products")
              .where("category", isEqualTo: categoryName)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<String> medicineList =
            querySnapshot.docs.map((doc) => doc["name"] as String).toList();
        return "🔍 '$categoryName' category me yeh medicines available hain:\n${medicineList.join(", ")}";
      }
      return "❌ '$categoryName' category me koi medicine available nahi hai.";
    } catch (e) {
      return "Error checking category availability.";
    }
  }

  void _addMessage(String role, String content) {
    _messages.add({"role": role, "content": content});
    notifyListeners();
  }
}
