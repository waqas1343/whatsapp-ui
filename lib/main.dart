import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medichat/core/utils/text_theme/text_theme.dart';
import 'package:medichat/firebase_options.dart';
import 'package:medichat/providers/multiapp_providers/multiapp_providers.dart';
import 'package:medichat/screens/auth/welcome_screen/welcome_screen.dart';
import 'package:medichat/screens/home/Ai_chat_screen/ai_chat_screen.dart';
import 'package:medichat/screens/home/custom_ai_chat_screen/custom_ai_chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'screens/home/whatsapp_dashboard_screen/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: multiAppProvider,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            home: DashboardScreen(),
          ),
        );
      },
    );
  }
}
