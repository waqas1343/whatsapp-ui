import 'package:flutter/material.dart';
import 'package:medichat/providers/controllers/personalChat/personal_chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../core/utils/color_utils/app_colors.dart';

class PersonalChat extends StatelessWidget {
  final String username;
  final String imageUrl;
  const PersonalChat({
    super.key,
    required this.username,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final pcp = Provider.of<PersonalChatProvider>(context);
    TextEditingController messageController = TextEditingController();
    final appTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(username, style: appTextTheme.headlineSmall),
        backgroundColor: AppColors.appColorG,

        leading: Padding(
          padding: EdgeInsets.only(left: 2.w),
          child: CircleAvatar(backgroundImage: AssetImage(imageUrl)),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.call, color: AppColors.appBackground),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.videocam, color: AppColors.appBackground),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {},
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: "View contact",
                  child: Text("View Contact"),
                ),
                PopupMenuItem(
                  value: "Media, links and docs",
                  child: Text("Media, links and docs"),
                ),
                PopupMenuItem(value: "Search", child: Text("Search")),
              ];
            },
            icon: Icon(Icons.more_vert, color: AppColors.appBackground),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: pcp.messages.length,
              itemBuilder: (context, index) {
                final mess = pcp.messages[index];
                return Align(
                  alignment:
                      mess["isMe"]
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                      color: mess["isMe"] ? Colors.blue[300] : Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(mess["text"], style: TextStyle(fontSize: 16)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,

                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Container(
                  width: 10.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: AppColors.appColorG,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      // pcp.sendmessage("hello! Bhai");
                      // Provider.of<PersonalChatProvider>(
                      //   context,
                      //   listen: false,
                      // ).sendmessage(message);
                      if (messageController.text.isNotEmpty) {
                        pcp.sendmessage(messageController.text);
                        messageController.clear();
                      }
                    },
                    icon: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
