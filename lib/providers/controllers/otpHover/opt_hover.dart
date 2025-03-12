import 'package:flutter/material.dart';

class OptHoverProvider extends ChangeNotifier {
  int? hoverIndex;

  void setHoverIndex(int? index) {
    hoverIndex = index;
    notifyListeners();
  }
}
