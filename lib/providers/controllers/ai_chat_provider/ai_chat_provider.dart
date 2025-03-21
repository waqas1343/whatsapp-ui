import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatProvider extends ChangeNotifier {
  final List<Map<String, String>> _messages = [];
  final String apiKey = "AIzaSyAzEhcrVkf7oa5SSeVhB5DCTT5CINKS3Qk";

  List<Map<String, String>> get messages => List.unmodifiable(_messages);

  Future<void> sendMessage(String message) async {
    _addMessage("user", message);

    if (isMedicineName(message)) {
   
      String? availabilityMessage = await checkMedicineAvailability(message);
      if (availabilityMessage != null) {
        _addMessage("bot", availabilityMessage);
        return; 
      }
    }

   
    if (isMedicalQuery(message)) {
      await fetchAIResponse(message);
    } else {
      _addMessage(
        "bot",
        "Maaf kijiye, mai sirf medical-related sawalon ka jawab de sakta hoon.",
      );
    }
  }

  
  Future<String?> checkMedicineAvailability(String medicineName) async {
    try {
      print(
        "Checking Firebase for medicine: $medicineName",
      ); 

      var querySnapshot =
          await FirebaseFirestore.instance
              .collection("products")
              .where(
                "name",
                isEqualTo: medicineName.toLowerCase(),
              ) 
              .limit(1)
              .get();

      print(
        "Query Result: ${querySnapshot.docs.length} documents found",
      ); 

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        int stock = doc["stock"] ?? 0;
        double price = doc["price"]?.toDouble() ?? 0.0;

        print("Stock: $stock, Price: $price"); 

        if (stock > 0) {
          return "✅ '$medicineName' store mein available hai. Price: Rs. $price. Kya aap isse buy karna chahenge?";
        } else {
          return "❌ '$medicineName' store mein abhi available nahi hai.";
        }
      }
      return "❌ '$medicineName' hamare store mein available nahi hai.";
    } catch (e) {
      print("Error checking Firebase: $e");
      return "Error checking medicine availability.";
    }
  }

  
  Future<void> fetchAIResponse(String message) async {
    try {
      final response = await http.post(
        Uri.parse(
          "https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash-001:generateContent?key=$apiKey",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text":
                      "The user has asked the following medical query: '$message'. Answer strictly in English and provide a concise medical response.",
                },
              ],
            },
          ],
          "generationConfig": {"maxOutputTokens": 50},
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final String reply =
            responseData["candidates"]?.isNotEmpty == true
                ? responseData["candidates"][0]["content"]["parts"][0]["text"] ??
                    "No response"
                : "No valid response from API";
        _addMessage("bot", reply);
      } else {
        _handleError(response);
      }
    } catch (e) {
      _addMessage("bot", "Error: Failed to connect to AI API.");
      print("AI API Error: $e");
    }
  }

 
  void _addMessage(String role, String content) {
    _messages.add({"role": role, "content": content});
    notifyListeners();
  }

 
  void _handleError(http.Response response) {
    _addMessage("bot", "Error: ${response.statusCode} - ${response.body}");
    print(
      "API Error: ${response.statusCode} - ${response.body}",
    ); 
  }

 
  bool isMedicineName(String message) {
    List<String> medicines = [
      "paracetamol",
      "ibuprofen",
      "aspirin",
      "panadol",
      "brufen",
    ];
    return medicines.contains(message.toLowerCase());
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
    return medicalKeywords.any(
      (keyword) => message.toLowerCase().contains(keyword),
    );
  }
}
