import 'package:medichat/providers/controllers/otpHover/opt_hover.dart';
import 'package:medichat/providers/controllers/terms_agrement/termsagrement.dart';
import 'package:provider/provider.dart';

final List<ChangeNotifierProvider> multiAppProvider = [
  ChangeNotifierProvider<Termsagrement>(create: (context) => Termsagrement()),
  ChangeNotifierProvider<OptHoverProvider>(
    create: (context) => OptHoverProvider(),
  ),
];
