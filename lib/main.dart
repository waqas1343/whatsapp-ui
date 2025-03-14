import 'package:flutter/material.dart';
import 'package:medichat/core/utils/text_theme/text_theme.dart';
import 'package:medichat/providers/multiapp_providers/multiapp_providers.dart';
import 'package:medichat/screens/auth/welcome_screen/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() {
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
            home: WelcomeScreen(),
          ),
        );
      },
    );
  }
}
