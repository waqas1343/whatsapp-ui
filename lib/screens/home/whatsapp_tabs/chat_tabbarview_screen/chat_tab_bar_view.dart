import 'package:flutter/material.dart';
import 'package:medichat/core/utils/app_images/app_images.dart';
import 'package:medichat/widgets/personalChat/personal_chat.dart';
import 'package:medichat/widgets/customChatTile/custom_chat_tile.dart';

class ChatTabBarView extends StatelessWidget {
  const ChatTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            CustomChatTile(
              profileImage: AppImages.waqasImage,
              name: 'Shahzaib',
              lastMessage: "Tap to chat",
              time: "",
              unreadCount: 0,
              ontap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonalChat(
                      username: 'Shahzaib',
                      imageUrl: AppImages.waqasImage,
                      receiverId: 'receiver_user_id',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
