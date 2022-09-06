import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:spyfall/providers/locations_provider.dart';
import 'package:spyfall/providers/room_provider.dart';
import 'package:spyfall/providers/user_provider.dart';
import 'package:spyfall/screens/game_screen.dart';
import 'package:spyfall/screens/homescreen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:spyfall/screens/lobby-screen.dart';
import 'package:spyfall/screens/rules-screen.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  if (kIsWeb) {
    await Firebase.initializeApp(
      // Replace with actual values
      options: const FirebaseOptions(
          apiKey: "AIzaSyCacocvKnYrpYLMgAvY2Zxppjf56dmpi9s",
          authDomain: "spyfall-e9282.firebaseapp.com",
          databaseURL: "https://spyfall-e9282-default-rtdb.firebaseio.com",
          projectId: "spyfall-e9282",
          storageBucket: "spyfall-e9282.appspot.com",
          messagingSenderId: "10744364462",
          appId: "1:10744364462:web:25d0dd74f37f72cfd59c3f",
          measurementId: "G-HT4LEHSW3Q"),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LocationProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => RoomProvider()),
      ChangeNotifierProvider(create: (_) => LocationImageProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _initGoogleMobileAds();
    // Firebase.initializeApp();

    return MaterialApp(
      // home: HomeScreen(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/lobby': (context) => LobbyScreen(),
        '/gameScreen': (context) => GameScreen(),
        '/rules': (context) => RulesScreen(),
      },
    );
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }
}
