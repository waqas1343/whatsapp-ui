import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../widgets/infoCard/info_card.dart';
import '../../Ai_chat_screen/ai_chat_screen.dart';

class ECommerceScreen extends StatelessWidget {
  const ECommerceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Wrap(
                children: [
                  InfoCard(
                    description: 'you can get more info about medicine',
                    title: 'medicine',
                    icon: Icons.medical_services,
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AiMedicineChatScreen(),
                        ),
                      );
                    },
                  ),
                  InfoCard(
                    description: 'you can get more info about clothes',
                    title: 'Clothes',
                    icon: Icons.shopping_bag,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
