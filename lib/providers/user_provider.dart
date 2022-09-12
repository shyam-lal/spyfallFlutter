import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spyfall/constants/strings.dart';

class UserProvider with ChangeNotifier {
  String _userName = "";
  bool? _isAdmin;
  int _versionCode = 0;

  String get userName => _userName;
  bool get isAdmin => _isAdmin!;
  int get versionCode => _versionCode;

  Future getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName') ?? "";
    notifyListeners();
  }

  Future setUserName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', name);
    _userName = name;
    notifyListeners();
  }

  setAdminStatus(bool admin) {
    _isAdmin = admin;
  }

  Future fetchVersionCode() async {
    final reference =
        await FirebaseDatabase.instance.ref().child(FirebaseKeys.updates);
    await reference.child('version').once().then((DatabaseEvent event) {
      final data = event.snapshot.value as String;
      _versionCode = int.parse(data.toString());
    });
    notifyListeners();
  }
}
