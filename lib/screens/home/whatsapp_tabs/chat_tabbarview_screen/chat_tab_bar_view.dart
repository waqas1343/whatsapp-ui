import 'package:flutter/material.dart';

class ChatTabBarView extends StatelessWidget {
  const ChatTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.cyan,
      body: Center(child: Text('Chat')),
    );
  }
}
