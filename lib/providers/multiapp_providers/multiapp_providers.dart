import 'package:medichat/providers/controllers/otpHover/opt_hover.dart';
import 'package:provider/provider.dart';

final List<ChangeNotifierProvider> multiAppProvider = [
  ChangeNotifierProvider<OptHoverProvider>(
    create: (context) => OptHoverProvider(),
  ),
];
