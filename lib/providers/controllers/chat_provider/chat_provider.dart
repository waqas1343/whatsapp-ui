import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatProvider2 extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  
  Future<void> sendMessage(String receiverId, String message) async {
    final senderId = auth.currentUser?.uid;
    if (senderId == null) return; 

    final chatId = getChatId(senderId, receiverId);

    await _firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': senderId,
      'text': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    notifyListeners();
  }

  
  Stream<QuerySnapshot> getMessages(String receiverId) {
    final senderId = auth.currentUser?.uid;
    if (senderId == null) return Stream.empty(); 

    final chatId = getChatId(senderId, receiverId);

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

 
  String getChatId(String user1, String user2) {
    return user1.hashCode <= user2.hashCode
        ? '${user1}_$user2'
        : '${user2}_$user1';
  }
}
