import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:spyfall/constants/strings.dart';

class RoomProvider with ChangeNotifier {
  // String _userName = "";
  // bool? _isAdmin;

  // String get userName => _userName;
  // bool get isAdmin => _isAdmin!;

  // Future getUserName() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _userName = prefs.getString('userName') ?? "";
  //   notifyListeners();
  // }

  // Future setUserName(String name) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('userName', name);
  //   _userName = name;
  //   notifyListeners();
  // }

  // setAdminStatus(bool admin) {
  //   _isAdmin = admin;
  // }

  Future deleteRoom(String roomId) async {
    final databaseRef = await FirebaseDatabase.instance
        .ref()
        .child(FirebaseKeys.rooms)
        .child(roomId);
    databaseRef.remove();
  }

  Future memeberLeave(String roomId, String name) async {
    final databaseRef = await FirebaseDatabase.instance
        .ref()
        .child(FirebaseKeys.rooms)
        .child(roomId)
        .child('players')
        .child(name);
    databaseRef.remove();
  }
}
