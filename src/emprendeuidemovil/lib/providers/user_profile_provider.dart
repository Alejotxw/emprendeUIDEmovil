import 'package:flutter/material.dart';

class UserProfileProvider with ChangeNotifier {
  String _name = 'Sebastián Chocho';
  String _phone = '09931762';
  String? _imagePath;

  String get name => _name;
  String get phone => _phone;
  String? get imagePath => _imagePath;

  void updateProfile({String? name, String? phone, String? imagePath}) {
    if (name != null) _name = name;
    if (phone != null) _phone = phone;
    if (imagePath != null) _imagePath = imagePath;
    notifyListeners();
  }
}
