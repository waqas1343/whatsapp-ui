import 'package:medichat/providers/controllers/ai_chat_provider/ai_chat_provider.dart';
import 'package:provider/provider.dart';

import '../controllers/personalChat/personal_chat_provider.dart';

final List<ChangeNotifierProvider> multiAppProvider = [
  ChangeNotifierProvider<ChatProvider>(create: (context) => ChatProvider()),
  ChangeNotifierProvider<PersonalChatProvider>(
    create: (context) => PersonalChatProvider(),
  ),
];
