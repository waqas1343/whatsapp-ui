import 'package:flutter/material.dart';

class PersonalChatProvider extends ChangeNotifier {
  List<Map<String, dynamic>> messages = [];

  void sendmessage(String message) {
    if (message.isEmpty) {
      return;
    }
    messages.add({"text": message, "isMe": true});
    notifyListeners();

    Future.delayed(Duration(seconds: 1), () {
      messages.add({"text": "Reply to: $message", "isMe": false});
      notifyListeners();
    });
  }
}
