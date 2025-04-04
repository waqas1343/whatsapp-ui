import 'package:flutter/material.dart';
import 'package:medichat/screens/home/whatsapp_tabs/call_tabbarview_screen/call_tab_bar_view.dart';
import 'package:medichat/screens/home/whatsapp_tabs/chat_tabbarview_screen/chat_tab_bar_view.dart';
import 'package:medichat/screens/home/whatsapp_tabs/group_tabbarview_screen/group_tab_bar_view.dart';
import 'package:medichat/widgets/custom_appbar_widget/appbar_widget.dart';

import '../Ai_chat_screen/ai_chat_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(),
        body: TabBarView(
          children: [
            Center(child: ChatTabBarView()),
            Center(child: GroupTabBarView()),
            Center(child: CallTabBarView()),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AiChatScreen()),
            );
          },
          backgroundColor: Colors.green,
          child: Icon(Icons.message),
        ),
      ),
    );
  }
}
