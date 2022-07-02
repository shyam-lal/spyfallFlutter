import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:spyfall/constants/strings.dart';

class LocationProvider with ChangeNotifier {
  List<dynamic> _locations = [];

  List<dynamic> get locations => _locations;

  // Fetch notifications
  Future getLocations() async {
    print(
        "**************************************************************************************************************************************************************************************************************");

    final databaseRef =
        FirebaseDatabase.instance.ref(); //database reference object
    await databaseRef
        .child(FirebaseKeys.locations)
        .once()
        .then((DatabaseEvent event) {
      _locations = event.snapshot.value as List<dynamic>;
      notifyListeners();
    });

    //   final databaseRef =
    //       await FirebaseDatabase.instance.reference(); //database reference object
    //   await databaseRef
    //       .child(FirebaseKeys.notifications)
    //       .once()
    //       .then((DataSnapshot snapshot) {
    //     final data = snapshot.value as Map<dynamic, dynamic>;
    //     _notifications =
    //         data.values.map((e) => NotificationModel.fromJson(e)).toList();
    //     notifyListeners();
    //   });
    // }

    // deleteNotification(int index) {
    //   _notifications.removeAt(index);
    //   notifyListeners();
    // }
  }
}
