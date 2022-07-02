import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spyfall/providers/locations_provider.dart';
import 'package:spyfall/screens/homescreen.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => LocationProvider())],
    child: MyApp(),
  ));
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
