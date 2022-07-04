import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spyfall/constants/strings.dart';
import 'package:spyfall/custom_widgets/alert.dart';
import 'package:spyfall/models/room_model.dart';
import 'package:spyfall/providers/user_provider.dart';
import 'package:spyfall/screens/lobby-screen.dart';

class HomeScreen extends StatelessWidget {
  List locations = [];
  String userName = "";

  @override
  Widget build(BuildContext context) {
    // userName = context.watch<UserProvider>().userName;

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  context.read<UserProvider>().setAdminStatus(true);
                  userName.isEmpty
                      ? showDialog(
                          context: context,
                          builder: (BuildContext buildContext) {
                            return AlertScreen('Enter Name', 'Create Room',
                                true, AlertType.name, '');
                          })
                      : createRoomTapped(context);
                },
                child: Text("CREATE ROOM")),
            ElevatedButton(
                onPressed: () {
                  context.read<UserProvider>().setAdminStatus(false);
                  showDialog(
                      context: context,
                      builder: (BuildContext buildContext) {
                        return userName.isEmpty
                            ? AlertScreen(
                                'Enter Name', 'Join', true, AlertType.name, '')
                            : AlertScreen('Room ID', 'Join Room', true,
                                AlertType.join, userName);
                      });
                },
                child: Text("JOIN ROOM"))
          ],
        ),
      ),
    );
  }

  createRoomTapped(BuildContext context) {
    final roomRef = FirebaseDatabase.instance.ref().child(FirebaseKeys.rooms);
    final roomId = generateRandomString(5);
    final roomModel = RoomModel(roomId, 'dummy', {userName: ''}, false);
    roomRef
        .child(roomId)
        // .set({'hello': 'world'}).whenComplete(() {
        .set(roomModel.toJson())
        .whenComplete(() {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LobbyScreen(roomId, true)));
    });
  }

  joinRoomTapped() {}

  // Future getNotifications() async {
  //   final databaseRef =
  //       FirebaseDatabase.instance.ref(); //database reference object
  //   await databaseRef
  //       .child(FirebaseKeys.locations)
  //       .once()
  //       .then((DatabaseEvent event) {
  //     final data = event.snapshot.value as List<dynamic>;
  //     return data;
  //   });
  // }

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