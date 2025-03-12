import 'package:medichat/providers/controllers/terms_agrement/termsagrement.dart';
import 'package:provider/provider.dart';

final List<ChangeNotifierProvider> multiAppProvider = [
  ChangeNotifierProvider<Termsagrement>(create: (context) => Termsagrement()),
];
