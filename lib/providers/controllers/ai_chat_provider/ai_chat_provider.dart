import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatProvider extends ChangeNotifier {
  final List<Map<String, String>> _messages = [];
  final String apiKey = "YOUR_API_KEY"; // Secure this key properly
  String? lastMedicineQueried;

  List<Map<String, String>> get messages => List.unmodifiable(_messages);

  Future<void> sendMessage(String message) async {
    _addMessage("user", message);

    String lowerMessage = message.toLowerCase().trim();
    print("User entered: $lowerMessage");

    if (lastMedicineQueried != null &&
        (lowerMessage == "yes" || lowerMessage == "haan")) {
      await placeOrder(lastMedicineQueried!);
      lastMedicineQueried = null;
      return;
    }

    var medicinesAndCategories = await fetchMedicinesAndCategories();
    List<String> availableMedicines = medicinesAndCategories["medicines"] ?? [];
    List<String> availableCategories =
        medicinesAndCategories["categories"] ?? [];

    if (availableMedicines.contains(lowerMessage)) {
      print("Detected as medicine name.");
      String? medicineDetails = await getMedicineDetails(lowerMessage);
      if (medicineDetails != null) {
        lastMedicineQueried = lowerMessage;
        _addMessage(
          "bot",
          "$medicineDetails\nKya aap isse buy karna chahenge? (yes/no)",
        );
        return;
      }
    }

    if (availableCategories.contains(lowerMessage)) {
      print("Detected as category name.");
      String? categoryResponse = await checkCategoryAvailability(lowerMessage);
      if (categoryResponse != null) {
        _addMessage("bot", categoryResponse);
        return;
      }
    }

    if (isMedicalQuery(lowerMessage)) {
      print("Detected as medical query.");
      await fetchAIResponse(lowerMessage);
    } else {
      _addMessage(
        "bot",
        "Maaf kijiye, mai sirf medical-related sawalon ka jawab de sakta hoon.",
      );
    }
  }

  Future<void> fetchAIResponse(String query) async {
    try {
      final response = await http.post(
        Uri.parse(
          "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$apiKey",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {"text": query},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String reply = data["candidates"][0]["content"]["parts"][0]["text"];
        _addMessage("bot", reply.trim());
      } else {
        print("API Error: ${response.body}");
        _addMessage("bot", "❌ AI se jawab lene mein error aayi.");
      }
    } catch (e) {
      print("Error fetching AI response: $e");
      _addMessage("bot", "❌ AI response fetch karne mein error aayi.");
    }
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
      print("Error fetching medicines & categories: $e");
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
        return "\u2728 '${doc["name"]}' ke details:\n\u2022 Description: ${doc["description"] ?? "No description"}\n\u2022 Price: Rs. ${doc["price"] ?? 0}\n\u2022 Stock: ${doc["stock"] ?? 0} available";
      }
      return "❌ '$medicineName' hamare store mein available nahi hai.";
    } catch (e) {
      print("Error fetching medicine details: $e");
      return "Error fetching medicine details.";
    }
  }

  Future<void> placeOrder(String medicineName) async {
    try {
      await FirebaseFirestore.instance.collection("orders").add({
        "medicine": medicineName,
        "status": "pending",
        "timestamp": FieldValue.serverTimestamp(),
      });
      _addMessage(
        "bot",
        "✅ Aapka order '$medicineName' ke liye place ho chuka hai! Jaldi hi aapko delivery details milengi.",
      );
    } catch (e) {
      print("Error placing order: $e");
      _addMessage(
        "bot",
        "❌ Order place karne mein error aayi. Kripya dobara koshish karein.",
      );
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
        return "🔍 Category: '$categoryName' ke andar yeh medicines available hain:\n\n${medicineList.join(", ")}";
      }
      return "❌ '$categoryName' category ke andar koi medicine available nahi hai.";
    } catch (e) {
      print("Error checking category in Firebase: $e");
      return "Error checking category availability.";
    }
  }

  void _addMessage(String role, String content) {
    print("Adding Message: $role - $content");
    _messages.add({"role": role, "content": content});
    notifyListeners();
  }

  bool isMedicalQuery(String message) {
    List<String> medicalKeywords = [
      "medicine",
      "tablet",
      "doctor",
      "pharmacy",
      "capsule",
      "fever",
      "infection",
      "pain",
      "headache",
      "flu",
      "cough",
      "cold",
      "disease",
      "diagnosis",
      "treatment",
    ];
    return medicalKeywords.any((keyword) => message.contains(keyword));
  }
}
