import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:provider/provider.dart';
import 'package:spyfall/constants/strings.dart';
import 'package:spyfall/custom_widgets/custombutton.dart';
import 'package:spyfall/models/room_model.dart';
import 'package:spyfall/providers/locations_provider.dart';
import 'package:spyfall/screens/game_screen.dart';

class LobbyScreen extends StatelessWidget {
  var currentLocation, playerRole;
  final String roomId, userName;
  final bool isAdmin;
  Map<dynamic, dynamic> locations = {};
  var roomDetails;
  LobbyScreen(this.roomId, this.isAdmin, this.userName);
  ////
  var countDownTime = 8;
  final timers = [5, 8, 10];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    print('---------------LobbyScreen--------------');
    if (!isAdmin) {
      listenForStarting(context);
    }
    locations = context.watch<LocationProvider>().locations;
    // playerName = context.watch<UserProvider>().userName;

    // .map((e) => e.toString())
    if (locations.isEmpty) {
      context.read<LocationProvider>().getLocations();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        child: Column(children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            height: screenHeight * 0.12,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: null, icon: Icon(Icons.person)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Invite Code: "),
                    // Share button
                    SizedBox(
                      height: screenHeight * 0.04,
                      child: ElevatedButton(
                        onPressed: () {
                          // Clipboard.setData(ClipboardData(text: "roomId"));
                          // Share.share('check out my website https://example.com');
                          // FlutterShare.share(title: 'title');
                          share();
                        },
                        child: Row(
                          children: [
                            Text(
                              roomId,
                              style: TextStyle(color: Colors.black),
                            ),
                            Icon(
                              Icons.share,
                              color: Colors.black,
                            )
                          ],
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(15))),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                      ),
                    )
                  ],
                ),
                IconButton(onPressed: null, icon: Icon(Icons.menu))
              ],
            ),
          ),
          // SizedBox(
          //   height: screenHeight * 0.05,
          // ),
          isAdmin
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timer),
                    TimerDropDown((index) {
                      countDownTime = timers[index];
                    })
                    // DropdownButton(
                    //   underline: SizedBox(),
                    //   value: selectedTime,
                    //   icon: const Icon(
                    //     Icons.keyboard_arrow_down,
                    //     size: 16,
                    //   ),
                    //   items: timers.map((items) {
                    //     return DropdownMenuItem(
                    //       value: items,
                    //       child: Text(
                    //         items,
                    //         style: TextStyle(fontSize: 13),
                    //       ),
                    //     );
                    //   }).toList(),
                    //   onChanged: (newValue) {
                    //     // setState(() {
                    //     //   selectedQuantity = newValue.toString();
                    //     // });
                    //   },
                    // )
                  ],
                )
              : SizedBox(),
          // SizedBox(
          //   height: screenHeight * 0.001,
          // ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
            height: screenHeight * 0.6,
            width: screenWidth * 0.6,
            color: Colors.white,
            child: StreamBuilder(
                stream: FirebaseDatabase.instance
                    .ref()
                    .child('rooms')
                    .child(roomId)
                    .child('players')
                    .onValue
                    .asBroadcastStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    print('Snapshot: ${snapshot.data.toString()}');
                    DatabaseEvent event = snapshot.data as DatabaseEvent;
                    final players =
                        event.snapshot.value as Map<dynamic, dynamic>;
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: players.length,
                        itemBuilder: (context, index) {
                          ////////////
                          ///////////
                          ///////////
                          //////////////////Player Item
                          return Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(1.0, 1.0),
                                      spreadRadius: 2.0,
                                      blurRadius: 2.0)
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Icon(Icons.person),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(players.keys.elementAt(index)),
                                ),
                                isAdmin
                                    ? IconButton(
                                        onPressed: () {
                                          kickUser(
                                              players.keys.elementAt(index));
                                        },
                                        icon: Icon(Icons.close))
                                    : SizedBox()
                              ],
                            ),
                          );
                        });
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ),
          SizedBox(
            height: screenHeight * 0.05,
          ),
          isAdmin
              ? SFButton('Start Game', screenHeight * 0.08, screenWidth * .5,
                  () {
                  startGame(context);
                })
              : SizedBox()
        ]),
      ),
    );
  }

  Future startGame(BuildContext context) async {
    final databaseRef =
        FirebaseDatabase.instance.ref().child(FirebaseKeys.rooms).child(roomId);

    final location = (locations.keys.toList()..shuffle()).first;
    currentLocation = location;
    await databaseRef.child('location').set(location);
    await databaseRef.child('time').set(countDownTime);
    // await databaseRef.child('isplaying').set(true);
    fetchRoomDetails(context, location);
  }

  Future fetchRoomDetails(BuildContext context, String location) async {
    final databaseRef =
        FirebaseDatabase.instance.ref().child(FirebaseKeys.rooms).child(roomId);

    final roles = locations[location];

    databaseRef.once().then((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      roomDetails = RoomModel.fromJson(data);
      final players = roomDetails.players as Map<dynamic, dynamic>;
      final playersShuffled = players.keys.toList()..shuffle();
      final randInt = Random().nextInt(playersShuffled.length);
      final spyPlayer = playersShuffled.elementAt(randInt);
      // databaseRef.child('players').child(players[spyPlayer]).set('spy');

      final uploadData = {};

      for (var i = 0; i < playersShuffled.length; i++) {
        uploadData[playersShuffled.elementAt(i)] = roles.elementAt(i);
      }

      // for (var i = 0; i < playersShuffled.length; i++) {
      databaseRef
          .child('players')
          // .set({playersShuffled.elementAt(i): roles.elementAt(i)});
          .set(uploadData);
      // }

      databaseRef.child('players').child(spyPlayer).set('spy').whenComplete(() {
        if (userName == spyPlayer) {
          playerRole = "spy";
        } else {
          playerRole = uploadData[userName];
        }

        databaseRef.child('isplaying').set(true);

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                GameScreen(currentLocation, playerRole, countDownTime)));
      });
    });
  }

  void listenForStarting(BuildContext context) {
    final databaseRef = FirebaseDatabase.instance.ref();
    final sub = databaseRef
        .child(FirebaseKeys.rooms)
        .child(roomId)
        .child('isplaying')
        .onValue
        .listen((event) {
      final value = event.snapshot.value as bool;
      if (value) {
        databaseRef
            .child(FirebaseKeys.rooms)
            .child(roomId)
            .once()
            .then((DatabaseEvent event) {
          final data = event.snapshot.value as Map<dynamic, dynamic>;
          roomDetails = RoomModel.fromJson(data);
          currentLocation = roomDetails.location;
          // final playerRole = roomDetails.players[userName];
          countDownTime = roomDetails.time;
          var players = roomDetails.players as Map<dynamic, dynamic>;
          playerRole = players[userName];
        }).then((value) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  GameScreen(currentLocation, playerRole, countDownTime)));
        });
      }
    });
  }

  ////////
  ////////
  /////////Share code
  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title');
  }

  Future kickUser(String playerName) async {
    final databaseRef =
        FirebaseDatabase.instance.ref().child(FirebaseKeys.rooms).child(roomId);
    databaseRef.child('players').child(playerName).remove();
  }
}

//Dropdown
class TimerDropDown extends StatefulWidget {
  // const TimerDropDown({Key? key}) : super(key: key);
  final ValueChanged<int> onTimerChanged;
  TimerDropDown(this.onTimerChanged);

  @override
  State<TimerDropDown> createState() => _TimerDropDownState();
}

class _TimerDropDownState extends State<TimerDropDown> {
  //drop down items
  var selectedTime = "8 min";
  // var timers = {5:'5 min',8: '8 min',10: '10 min'};
  var timers = ['5 min', '8 min', '10 min'];

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      underline: SizedBox(),
      value: selectedTime,
      icon: const Icon(
        Icons.keyboard_arrow_down,
        size: 16,
      ),
      items: timers.map((items) {
        return DropdownMenuItem(
          value: items,
          child: Text(
            items,
            style: TextStyle(fontSize: 13),
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        // final index = timers.values.firstWhere((element) => false)
        // List<String> values = timers.values as List<String>;
        widget.onTimerChanged(timers.indexOf(newValue.toString()));
        setState(() {
          selectedTime = newValue.toString();
        });
      },
    );
  }
}
