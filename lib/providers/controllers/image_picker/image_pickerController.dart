import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileProvider with ChangeNotifier {
  XFile? _pickedImage;
  TextEditingController nameController = TextEditingController();
  String? phoneNumber;

  XFile? get pickedImage => _pickedImage;
  String get name => nameController.text.trim();

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _pickedImage = image;
      notifyListeners();
    }
  }

  bool validateProfile() {
    if (name.isEmpty || _pickedImage == null) {
      return false;
    }
    return true;
  }

  void clear() {
    _pickedImage = null;
    nameController.clear();
    notifyListeners();
  }

  void setPhoneNumber(String number) {
    phoneNumber = number;
    notifyListeners();
  }
}
