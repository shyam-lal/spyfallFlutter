import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spyfall/constants/strings.dart';
import 'package:spyfall/custom_widgets/alert.dart';
import 'package:spyfall/custom_widgets/custombutton.dart';
import 'package:spyfall/custom_widgets/loading-alert.dart';
import 'package:spyfall/models/room_model.dart';
import 'package:spyfall/providers/user_provider.dart';
import 'package:spyfall/screens/lobby-screen.dart';

class HomeScreen extends StatelessWidget {
  List locations = [];
  String? userName;

  @override
  Widget build(BuildContext context) {
    print("******************");
    // userName = context.watch<UserProvider>().userName;
    if (userName == null) {
      context.read<UserProvider>().getUserName();
    }
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    userName = context.watch<UserProvider>().userName;
    // final nameController = new TextEditingController();
    // nameController.text = userName!;

    return Scaffold(
      body: Container(
        width: screenWidth,
        // height: screenHeight,
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.025,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: null, icon: Icon(Icons.share)),
                // PopupMenuButton(
                //   icon: Icon(Icons.menu),
                //   onSelected: (value) {
                //     if (value == 1) {
                //       // deleteNotification(context);
                //       print("Delete");
                //     } else {
                //       // approveNotifcation(context);
                //       print("Approve");
                //     }
                //   },
                //   // child: (userData!.access != 0)
                //   //     ? Center(child: Icon(Icons.menu))
                //   //     : SizedBox(),
                //   itemBuilder: (context) {
                //     return [
                //       PopupMenuItem(value: 1, child: Text("How to play")),
                //       PopupMenuItem(value: 2, child: Text(""))
                //     ];
                //   },
                // ),
                IconButton(
                    onPressed: null, icon: Icon(Icons.help_outline_sharp))
              ],
            ),
            // SizedBox(
            //   height: screenHeight * 0.025,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome $userName",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
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
                          ? AlertScreen(
                              'Enter Name', 'Join', true, AlertType.name, '')
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
            )
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
}


// .then((DataSnapshot snapshot) {
//       final data = snapshot.value as Map<dynamic, dynamic>;
//       // _notifications =
//       //     data.values.map((e) => CalendarDataModel.fromJson(e)).toList();
//       // notifyListeners();
//     });