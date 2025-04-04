import 'package:flutter/material.dart';
import 'package:medichat/core/utils/color_utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final appTextTheme = Theme.of(context).textTheme;

    return AppBar(
      backgroundColor: AppColors.appColorG,
      title: Text('WhatsApp', style: appTextTheme.headlineSmall),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search, color: AppColors.appBackground),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {},
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(value: "New Group", child: Text("New Group")),
              PopupMenuItem(
                value: "New Broadcast",
                child: Text("New Broadcast"),
              ),
              PopupMenuItem(
                value: "Linked Devices",
                child: Text("Linked Devices"),
              ),
              PopupMenuItem(value: "Settings", child: Text("Settings")),
            ];
          },
          icon: Icon(Icons.more_vert, color: AppColors.appBackground),
        ),
      ],
      bottom: TabBar(
        labelStyle: appTextTheme.bodyMedium,
        indicatorColor: Colors.white,
        unselectedLabelColor: AppColors.shadowGrey,
        tabs: [
          Tab(text: 'CHAT'),
          Tab(text: 'GROUPS'),
          Tab(text: 'CALLS'),
          Tab(text: 'E-COMMERCE'),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 48);
}
