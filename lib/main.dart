import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spyfall/screens/homescreen.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();

    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
