import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spyfall/constants/strings.dart';

import 'package:spyfall/custom_widgets/sf_widgets.dart';
import 'package:spyfall/providers/room_provider.dart';

class ExitAlert extends StatelessWidget {
  final int exitType;
  final String roomId;
  ExitAlert(this.roomId, this.exitType);
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
        backgroundColor: Color.fromARGB(255, 249, 249, 249),
        content: Container(
          width: screenWidth * 0.6,
          // height: screenHeight * 0.25,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                exitType == 0
                    ? "Exiting will delete the room because you are the admin"
                    : "Exiting will start a new round",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              SFSpace(0.025, 0),
              // Image.asset(
              //   "assets/images/timer.png",
              //   width: screenWidth * 0.15,
              // ),
              SFSpace(0.025, 0),
              ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.black)))),
                  onPressed: () {
                    exitType == 0 ? deleteRoom(context) : restartRound(context);
                    // Navigator.pop(context);
                  },
                  child: Text(exitType == 0 ? "Close Room" : "Restart Round"))
              // const Text("Guess the spy in your midst")
            ],
          ),
        ));
  }

  Future deleteRoom(BuildContext context) async {
    // final databaseRef = await FirebaseDatabase.instance
    //     .ref()
    //     .child(FirebaseKeys.rooms)
    //     .child(roomId);
    // databaseRef.remove().then((value) {
    //   final nav = Navigator.of(context);
    //   nav.pop();
    //   nav.pop();
    // });
    context.read<RoomProvider>().deleteRoom(roomId);
    Navigator.popUntil(context, ModalRoute.withName('/'));
    // final nav = Navigator.of(context);
    // nav.pop();
    // nav.pop();
  }

  Future restartRound(BuildContext context) async {
    final databaseRef = await FirebaseDatabase.instance
        .ref()
        .child(FirebaseKeys.rooms)
        .child(roomId);
    databaseRef.child('isPlaying').set(false).then((value) {
      Navigator.pop(context);
    });
  }
}
