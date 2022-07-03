import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:spyfall/constants/strings.dart';

class UserProvider with ChangeNotifier {
  String _userName = "";
  bool? _isAdmin;

  String get userName => _userName;
  bool get isAdmin => _isAdmin!;

  setUserName(String name) {
    _userName = name;
  }

  setAdminStatus(bool admin) {
    _isAdmin = admin;
  }
}
