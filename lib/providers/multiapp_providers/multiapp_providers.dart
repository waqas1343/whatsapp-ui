import 'package:medichat/providers/controllers/ai_chat_provider/ai_chat_provider.dart';
import 'package:medichat/providers/controllers/chat_provider/chat_provider.dart';

import 'package:medichat/providers/controllers/validation/validation.dart';
import 'package:provider/provider.dart';
import '../controllers/personalChat/personal_chat_provider.dart';

final List<ChangeNotifierProvider> multiAppProvider = [
  ChangeNotifierProvider<ChatProvider>(create: (context) => ChatProvider()),

  ChangeNotifierProvider<PersonalChatProvider>(
    create: (context) => PersonalChatProvider(),
  ),
  ChangeNotifierProvider<Validation>(create: (context) => Validation()),

  /////////////////////

  ////////////////////
  ChangeNotifierProvider<ChatProvider2>(create: (context) => ChatProvider2()),

  ChangeNotifierProvider<PersonalChatProvider>(
    create: (context) => PersonalChatProvider(),
  ),
];
