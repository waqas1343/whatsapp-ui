import 'package:medichat/providers/controllers/ai_chat_provider/medical_ai_chat_provider.dart';
import 'package:medichat/providers/controllers/chat_provider/chat_provider.dart';
import 'package:medichat/providers/controllers/clothing_provider/clothing_provider.dart';

import 'package:medichat/providers/controllers/validation/validation.dart';
import 'package:provider/provider.dart';
import '../controllers/image_picker/image_pickerController.dart';
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
  ChangeNotifierProvider<ClothingChatProvider>(
    create: (context) => ClothingChatProvider(),
  ),
  ChangeNotifierProvider<ProfileProvider>(
    create: (context) => ProfileProvider(),
  ),
];
