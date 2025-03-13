import 'package:medichat/providers/controllers/ai_chat_provider/ai_chat_provider.dart';
import 'package:medichat/providers/controllers/otpHover/opt_hover.dart';
import 'package:provider/provider.dart';

final List<ChangeNotifierProvider> multiAppProvider = [
  ChangeNotifierProvider<OptHoverProvider>(
    create: (context) => OptHoverProvider(),
  ),
  ChangeNotifierProvider<ChatProvider>(create: (context) => ChatProvider()),
];
