import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:spyfall/constants/strings.dart';
import 'package:spyfall/custom_widgets/ad-widgets.dart';
import 'package:spyfall/custom_widgets/alert.dart';
import 'package:spyfall/custom_widgets/custombutton.dart';
import 'package:spyfall/custom_widgets/loading-alert.dart';
import 'package:spyfall/custom_widgets/update_alert.dart';
import 'package:spyfall/managers/g_ads_manager.dart';
import 'package:spyfall/models/room_model.dart';
import 'package:spyfall/providers/user_provider.dart';
import 'package:spyfall/screens/lobby-screen.dart';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  List locations = [];
  String? userName;
  int? versionCode;

  @override
  Widget build(BuildContext context) {
    print("******************");
    // userName = context.watch<UserProvider>().userName;
    if (userName == null) {
      context.read<UserProvider>().getUserName();
    }
    if (versionCode == 0) {
      context.read<UserProvider>().fetchVersionCode();
    }
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    userName = context.watch<UserProvider>().userName;
    versionCode = context.watch<UserProvider>().versionCode;
    if (!kIsWeb) {
      checkForUpdates(context, versionCode!);
    }

    // final nameController = new TextEditingController();
    // nameController.text = userName!;

    return Scaffold(
      body: Container(
        width: screenWidth,
        // height: screenHeight,
        child: ListView(
          children: [
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: share, icon: Icon(Icons.share)),
                kIsWeb
                    ? IconButton(
                        onPressed: () {
                          openURL(
                              'https://play.google.com/store/apps/details?id=com.inceptra.spyfall');
                        },
                        icon: Image.asset('assets/images/playstore.png'))
                    : IconButton(
                        onPressed: () {
                          openURL('https://spyfall-e9282.web.app/');
                        },
                        icon: Image.asset('assets/images/globe.png')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome $userName ",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return NameAlert();
                          });
                    },
                    icon: Icon(Icons.edit))
              ],
            ),
            SizedBox(
              height: screenHeight * 0.15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SPYFALL",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.1,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.1, 0, screenWidth * 0.1, 0),
              child: SFButton(
                  "CREATE ROOM", screenHeight * 0.08, screenWidth * .5, () {
                context.read<UserProvider>().setAdminStatus(true);
                userName!.isEmpty
                    ? showDialog(
                        context: context,
                        builder: (BuildContext buildContext) {
                          return AlertScreen('Enter Name', 'Create Room', true,
                              AlertType.name, '');
                        })
                    : createRoomTapped(context);
              }),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.1, 0, screenWidth * 0.1, 0),
              child: SFButton(
                  "JOIN ROOM", screenHeight * 0.08, screenWidth * .5, () {
                context.read<UserProvider>().setAdminStatus(false);
                showDialog(
                    context: context,
                    builder: (BuildContext buildContext) {
                      return userName!.isEmpty
                          ? AlertScreen('Enter Name', 'Enter Name', true,
                              AlertType.name, '')
                          : AlertScreen('Room ID', 'Join Room', true,
                              AlertType.join, userName!);
                    });
              }),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/rules');
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Center(
                  child: Text(
                    "How to play",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.16,
            ),
            SFBannerAd(AdManager.bannerAdUnitTestId)
          ],
        ),
      ),
    );
  }

  createRoomTapped(BuildContext context) {
    showDialog(
        // barrierDismissible: false,
        context: context,
        builder: (BuildContext buildContext) {
          return WillPopScope(
              onWillPop: () => Future.value(false),
              child: LoadingAlert("Creating World.........."));
          //
          //
        });
    final roomRef = FirebaseDatabase.instance.ref().child(FirebaseKeys.rooms);
    final roomId = generateRandomString(5);
    final roomModel = RoomModel(roomId, 'dummy', {userName: ''}, false, 8);
    roomRef
        .child(roomId)
        // .set({'hello': 'world'}).whenComplete(() {
        .set(roomModel.toJson())
        .whenComplete(() {
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => LobbyScreen(roomId, true, userName!)));
      Navigator.pushNamed(context, '/lobby',
          arguments: {'roomId': roomId, 'isAdmin': true, 'userName': userName});
    });
  }

  joinRoomTapped() {}

  Future getNotifications() async {
    final databaseRef = FirebaseDatabase.instance
        .ref(FirebaseKeys.locations); //database reference object
    await databaseRef
        // .child(FirebaseKeys.locations)
        .once()
        .then((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      print(data);
    });
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join()
        .toString();
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text:
            'Hello there \nPlay SPYFALL using our android app\nhttps://play.google.com/store/apps/details?id=com.inceptra.spyfall\nor using our webapp https://spyfall-e9282.web.app/ and play together',
        // linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title');
  }

  Future<void> openURL(String _url) async {
    await launch(_url,
        forceSafariVC: true, forceWebView: true, enableJavaScript: true);
  }

  Future checkForUpdates(BuildContext context, int remoteCode) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String version = packageInfo.version;
    String code = packageInfo.buildNumber;
    if (int.parse(code) < remoteCode) {
      showDialog(
          // barrierDismissible: false,
          context: context,
          builder: (BuildContext buildContext) {
            return WillPopScope(
                onWillPop: () => Future.value(false), child: UpdateAlert());
            //
            //
          });
    }
  }
}

class NameAlert extends StatelessWidget {
  // const NameAlert({Key? key}) : super(key: key);
  TextEditingController nameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 249, 249, 249),
      content: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              // keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              controller: nameController,
              decoration: InputDecoration(
                  hintText: "Enter Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  fillColor: Colors.white,
                  filled: true),
            ),
            //Button
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.black)))),
                  onPressed: () {
                    context
                        .read<UserProvider>()
                        .setUserName(nameController.text);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Change Name",
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
