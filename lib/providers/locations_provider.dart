import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:spyfall/constants/strings.dart';

class LocationProvider with ChangeNotifier {
  Map<dynamic, dynamic> _locations = {};
  Map<dynamic, dynamic> get locations => _locations;

  // Map<String, bool> _locationImages = {
  //   // 'bank.png': false,
  //   'beach.png': false,
  //   'circus.png': false,
  //   'hotel.png': false,
  //   'restaurant.png': false,
  //   'school.png': false,
  //   'hospital.png': false,
  //   'military-base.png': false,
  //   'police-station.png': false,
  //   'space-station.png': false,
  //   'supermarket.png': false,
  //   'theater.png': false,
  //   'university.png': false,
  // };

  // Map<String, bool> get locationImages => _locationImages;

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
      _locations = event.snapshot.value as Map<dynamic, dynamic>;
      notifyListeners();
    });
  }

  // toggleSelection(String key) {
  //   _locationImages[key] = !_locationImages[key]!;
  //   notifyListeners();
  // }

  // resetImage() {
  //   _locationImages.keys.map((e) {
  //     _locationImages[e] = false;
  //   }).toList();
  //   notifyListeners();
  // }
}

class LocationImageProvider with ChangeNotifier {
  Map<String, bool> _locationImages = {
    // 'bank.png': false,
    'beach.png': false,
    'circus.png': false,
    'hotel.png': false,
    'restaurant.png': false,
    'school.png': false,
    'hospital.png': false,
    'military-base.png': false,
    'police-station.png': false,
    'space-station.png': false,
    'supermarket.png': false,
    'theater.png': false,
    'university.png': false,
    'airplane.png': false,
    'casino.png': false,
    'submarine.png': false,
    'pirate-ship.png': false,
    'train.png': false,
    'movie-studio.png': false,
    'railway-station.png': false,
    'zoo.png': false,
  };

  Map<String, bool> get locationImages => _locationImages;

  toggleSelection(String key) {
    _locationImages[key] = !_locationImages[key]!;
    notifyListeners();
  }

  resetImage() {
    _locationImages.keys.map((e) {
      _locationImages[e] = false;
    }).toList();
    notifyListeners();
  }
}
