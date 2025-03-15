import 'package:medichat/providers/controllers/ai_chat_provider/ai_chat_provider.dart';

import 'package:medichat/providers/controllers/chat_provider/chat_provider.dart';



import 'package:medichat/providers/controllers/otp_controller/otp_verify_controller.dart';
import 'package:medichat/providers/controllers/phone_verification_controller/phone_verification_controller.dart';
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
  ChangeNotifierProvider<PhoneAuthProvider>(
    create: (context) => PhoneAuthProvider(),
  ),
  ChangeNotifierProvider<OtpController>(create: (context) => OtpController()),
  ////////////////////

  ChangeNotifierProvider<ChatProvider2>(create: (context) => ChatProvider2()),


  ChangeNotifierProvider<PersonalChatProvider>(
    create: (context) => PersonalChatProvider(),
  ),

];
