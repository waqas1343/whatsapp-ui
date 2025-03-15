import 'package:flutter/material.dart';
class CustomChatTile extends StatelessWidget {
  final String profileImage;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final VoidCallback ontap;
  const CustomChatTile({
    super.key,
    required this.profileImage,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    final apptextTheme = Theme.of(context).textTheme;
    return Expanded(
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: ontap,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              leading: CircleAvatar(
                backgroundImage: AssetImage(profileImage),
                radius: 25,
              ),
              title: Text(
                name,
                style: apptextTheme.headlineSmall?.copyWith(
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                lastMessage,
                style: apptextTheme.labelMedium?.copyWith(color: Colors.grey),
              ),
              trailing: Column(
                children: [
                  Text(
                    time,
                    style: apptextTheme.titleMedium?.copyWith(
                      color: Colors.green,
                    ),
                  ),
                  unreadCount > 0
                      ? Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          unreadCount.toString(),
                          style: apptextTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      )
                      : SizedBox(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
