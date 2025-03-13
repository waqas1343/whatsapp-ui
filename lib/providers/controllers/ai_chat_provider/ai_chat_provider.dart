import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatProvider extends ChangeNotifier {
  final String apiKey = "AIzaSyAzEhcrVkf7oa5SSeVhB5DCTT5CINKS3Qk";
  final List<Map<String, String>> _messages = [];

  List<Map<String, String>> get messages => List.unmodifiable(_messages);

  Future<void> sendMessage(String message) async {
    _addMessage("user", message);

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
                {"text": message},
              ],
            },
          ],
          "generationConfig": {"maxOutputTokens": 100},
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
      _addMessage("bot", "Error: Failed to connect to API.");
    }
  }

  void _addMessage(String role, String content) {
    _messages.add({"role": role, "content": content});
    notifyListeners();
  }

  void _handleError(http.Response response) {
    _addMessage("bot", "Error: ${response.statusCode} - ${response.body}");
  }
}
