import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medichat/providers/controllers/chat_provider/chat_provider.dart';

class PersonalChat extends StatelessWidget {
  final String username;
  final String imageUrl;
  final String receiverId;

  PersonalChat({super.key, 
    required this.username,
    required this.imageUrl,
    required this.receiverId,
  });

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider2>(context, listen: false);
    final currentUser = chatProvider.auth.currentUser;

   
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text(username)),
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
            SizedBox(width: 10),
            Text(username),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getMessages(receiverId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No messages yet"));
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final data =
                        snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;
                    final isMe = data['senderId'] == currentUser.uid;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[300] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(data['text']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(chatProvider),
        ],
      ),
    );
  }

  Widget _buildMessageInput(ChatProvider2 chatProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                chatProvider.sendMessage(receiverId, _messageController.text);
                _messageController.clear();

                Future.delayed(Duration(milliseconds: 300), () {
                  _scrollController.animateTo(
                    0.0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
