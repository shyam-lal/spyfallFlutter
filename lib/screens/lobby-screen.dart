import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:provider/provider.dart';
import 'package:spyfall/constants/strings.dart';
import 'package:spyfall/custom_widgets/ad-widgets.dart';
import 'package:spyfall/custom_widgets/alerts/exit_alert.dart';
import 'package:spyfall/custom_widgets/alerts/loading-alert.dart';
import 'package:spyfall/custom_widgets/custombutton.dart';

import 'package:spyfall/managers/g_ads_manager.dart';
import 'package:spyfall/models/room_model.dart';
import 'package:spyfall/providers/locations_provider.dart';
import 'package:spyfall/providers/room_provider.dart';
import 'package:spyfall/screens/game_screen.dart';
import 'package:spyfall/utitlities/popup-messages.dart';

class LobbyScreen extends StatelessWidget {
  var currentLocation, playerRole;
  String? roomId, userName;
  bool? isAdmin;
  Map<dynamic, dynamic> locations = {};
  var roomDetails;
  // LobbyScreen(this.roomId, this.isAdmin, this.userName);
  ////
  var spyCount = "";
  var countDownTime = 8;
  final timers = [5, 8, 10];

  @override
  Widget build(BuildContext context) {
    ////From route
    spyCount = '1';
    final routes =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    roomId = routes['roomId'].toString();
    userName = routes['userName'].toString();
    isAdmin = routes['isAdmin'] as bool;

    ///
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    print('---------------LobbyScreen--------------');
    print('=================${ModalRoute.of(context)?.settings.name}');
    if (!isAdmin!) {
      listenForStarting(context);
    }
    checkifRoomExists(context);
    locations = context.watch<LocationProvider>().locations;
    // playerName = context.watch<UserProvider>().userName;

    // .map((e) => e.toString())
    if (locations.isEmpty) {
      context.read<LocationProvider>().getLocations();
    }

    return WillPopScope(
      onWillPop: () {
        navigateHome(context);
        return Future.value(false);
      },
      child: Scaffold(
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
                  IconButton(
                      onPressed: () {
                        navigateHome(context);
                      },
                      icon: Icon(Icons.home)),
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
                                roomId!,
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
                  SizedBox()
                  // IconButton(onPressed: null, icon: Icon(Icons.menu))
                ],
              ),
            ),
            // SizedBox(
            //   height: screenHeight * 0.05,
            // ),
            isAdmin!
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.timer),
                          TimerDropDown((index) {
                            countDownTime = timers[index];
                          })
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Spies: "),
                          // TimerDropDown((index) {
                          //   countDownTime = timers[index];
                          // })
                          SpyCountDropDown((value) {
                            spyCount = value;
                          })
                        ],
                      ),
                    ],
                  )
                : SizedBox(),
            // SizedBox(
            //   height: screenHeight * 0.001,
            // ),
            Text(userName.toString()),

            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 5),
              height: screenHeight * 0.5,
              width: screenWidth * 0.6,
              color: Colors.white,
              child: StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .ref()
                      .child('rooms')
                      .child(roomId!)
                      .child('players')
                      .onValue
                      .asBroadcastStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      print('Snapshot: ${snapshot.data.toString()}');
                      DatabaseEvent event = snapshot.data as DatabaseEvent;
                      final players;
                      if (event.snapshot.value != null) {
                        players = event.snapshot.value as Map<dynamic, dynamic>;
                      } else {
                        return SizedBox();
                      }

                      return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: players.length,
                          itemBuilder: (context, index) {
                            ////////////
                            ///////////
                            ///////////
                            //////////////////Player Item
                            return (players.keys.elementAt(index) != userName)
                                ? Container(
                                    height: screenHeight * 0.05,
                                    margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    // padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(1.0, 1.0),
                                              spreadRadius: 2.0,
                                              blurRadius: 2.0)
                                        ]),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Icon(Icons.person),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 0, 0),
                                          child: Text(
                                              players.keys.elementAt(index)),
                                        ),
                                        isAdmin!
                                            ? IconButton(
                                                onPressed: () {
                                                  // if () {

                                                  // }
                                                  kickUser(players.keys
                                                      .elementAt(index));
                                                },
                                                icon: Icon(Icons.close))
                                            : SizedBox()
                                      ],
                                    ),
                                  )
                                : SizedBox();
                          });
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            isAdmin!
                ? SFButton('Start Game', screenHeight * 0.08, screenWidth * .5,
                    () {
                    startGame(context);
                  })
                : SizedBox(),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            // SFBannerAd(AdManager.bannerAdUnitTestId)
            // adsenseAdsView(screenWidth)
          ]),
        ),
      ),
    );
  }

  void navigateHome(BuildContext context) {
    if (isAdmin!) {
      showDialog(
          context: context,
          builder: (BuildContext buildContext) {
            return ExitAlert(roomId!, 0);
          });
    } else {
      context.read<RoomProvider>().memeberLeave(roomId!, userName!);
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
  }

  Future startGame(BuildContext context) async {
    showDialog(
        // barrierDismissible: false,
        context: context,
        builder: (BuildContext buildContext) {
          return WillPopScope(
              onWillPop: () => Future.value(false),
              child: LoadingAlert("Collecting Locations.........."));
          //
          //
        });
    final databaseRef = FirebaseDatabase.instance
        .ref()
        .child(FirebaseKeys.rooms)
        .child(roomId!);

    final location = (locations.keys.toList()..shuffle()).first;
    currentLocation = location;
    await databaseRef.child('location').set(location);
    await databaseRef.child('time').set(countDownTime);
    // await databaseRef.child('isplaying').set(true);
    fetchRoomDetails(context, location);
  }

  Future fetchRoomDetails(BuildContext context, String location) async {
    final databaseRef = FirebaseDatabase.instance
        .ref()
        .child(FirebaseKeys.rooms)
        .child(roomId!);

    final roles = locations[location];

    try {
      await databaseRef.once().then((DatabaseEvent event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        roomDetails = RoomModel.fromJson(data);
        final players = roomDetails.players as Map<dynamic, dynamic>;
        // final playersShuffled = players.keys.toList()..shuffle();
        final playersShuffled = players.keys.toList();

        // final randInt = Random().nextInt(playersShuffled.length - 1);

        final uploadData = {};

        if (players.length <= 12) {
          if (players.length < 6 && spyCount == "2") {
            Navigator.pop(context);
            Messages.displayMessage(
                context, "You need atleast six players to have 2 spies");
          } else {
            // Set roles
            for (var i = 0; i < playersShuffled.length; i++) {
              if (roles.length > i) {
                uploadData[playersShuffled.elementAt(i)] = roles.elementAt(i);
              } else {
                uploadData[playersShuffled.elementAt(i)] =
                    roles.elementAt(i ~/ 2);
              }
            }

            // for (var i = 0; i < playersShuffled.length; i++) {
            databaseRef
                .child('players')
                // .set({playersShuffled.elementAt(i): roles.elementAt(i)});
                .set(uploadData);
            // }

            //// Random number generator
            // var randomizer = new Random();
            // var randomInts = List.generate(int.parse(spyCount),
            //     (index) => randomizer.nextInt(playersShuffled.length));
            var randomInts = [
              for (var i = 0; i <= (playersShuffled.length - 1); i++) i
            ].toList();
            randomInts.shuffle();

            // randomInts.add(Random().nextInt(playersShuffled.length - 1));
            List<String> spyPlayers = [];

            // Spy Selection
            print("+++++++++++++++++++++$randomInts");
            if (spyCount == "2") {
              spyPlayers.add(playersShuffled.elementAt(randomInts.first));
              spyPlayers.add(playersShuffled.elementAt(randomInts[1]));

              // databaseRef.child("players").child(spyPlayers[1]).set('spy');

              databaseRef
                  .child('players')
                  .child(spyPlayers.first)
                  .set('spy')
                  .whenComplete(() {
                databaseRef
                    .child("players")
                    .child(spyPlayers[1])
                    .set('spy')
                    .whenComplete(() {
                  if (userName == spyPlayers.first ||
                      userName == spyPlayers[1]) {
                    playerRole = "spy";
                  } else {
                    playerRole = uploadData[userName];
                  }

                  databaseRef.child('isplaying').set(true);
                  Navigator.pushNamed(context, '/gameScreen', arguments: {
                    'location': currentLocation,
                    'role': playerRole,
                    'time': countDownTime,
                    'id': roomId,
                    'spies': spyPlayers
                  }).whenComplete(() {
                    print("000000000000");
                  });
                });
              });
            } else {
              spyPlayers.add(playersShuffled.elementAt(randomInts.first));
              //
              databaseRef
                  .child('players')
                  .child(spyPlayers.first)
                  .set('spy')
                  .whenComplete(() {
                if (userName == spyPlayers.first) {
                  playerRole = "spy";
                } else {
                  playerRole = uploadData[userName];
                }

                databaseRef.child('isplaying').set(true);
                Navigator.pushNamed(context, '/gameScreen', arguments: {
                  'location': currentLocation,
                  'role': playerRole,
                  'time': countDownTime,
                  'id': roomId,
                  'spies': spyPlayers
                }).whenComplete(() {
                  print("000000000000");
                });
              });
            }
            //
            //

          }
        } else {
          Messages.displayMessage(context, 'Max number of players are eight.');
        }
      });
    } catch (e) {
      Navigator.pop(context);
      Messages.displayMessage(context, 'Need more than one player');
    }
  }

  void listenForStarting(BuildContext context) {
    List<String> spies = [];
    final databaseRef = FirebaseDatabase.instance.ref();
    final sub = databaseRef
        .child(FirebaseKeys.rooms)
        .child(roomId!)
        .child('isplaying')
        .onValue
        .listen((event) {
      final value = event.snapshot.value as bool;
      if (value) {
        databaseRef
            .child(FirebaseKeys.rooms)
            .child(roomId!)
            .once()
            .then((DatabaseEvent event) {
          final data = event.snapshot.value as Map<dynamic, dynamic>;
          roomDetails = RoomModel.fromJson(data);
          currentLocation = roomDetails.location;
          // final playerRole = roomDetails.players[userName];
          countDownTime = roomDetails.time;
          var players = roomDetails.players as Map<dynamic, dynamic>;
          playerRole = players[userName];
          if (playerRole == 'spy') {
            // spies.add(userName);
            for (var key in players.keys) {
              if (players[key] == 'spy') {
                spies.add(key);
                // spies.add(players.entries.firstWhere((element) => element));
              }
            }
          }
        }).then((value) {
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => GameScreen(
          //         currentLocation, playerRole, countDownTime, roomId!)));
          Navigator.pushNamed(context, '/gameScreen', arguments: {
            'location': currentLocation,
            'role': playerRole,
            'time': countDownTime,
            'id': roomId,
            'spies': spies.isEmpty ? [''] : spies
          }).whenComplete(() {
            print("000000000000");
          });
        });
      }
    });
  }

  ///
  ///Check if room exists
  void checkifRoomExists(BuildContext context) {
    final databaseRef = FirebaseDatabase.instance.ref();
    databaseRef
        .child(FirebaseKeys.rooms)
        .child(roomId!)
        .onChildRemoved
        .listen((event) {
      print("Room CLosed ++++++++++++++++++");
      Navigator.popUntil(context, ModalRoute.withName('/'));
    });
  }

  ////////
  ////////
  /////////Share code
  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Join Spyfall lobby using code "$roomId"',
        // linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title');
  }

  ////
  ////
  ////Kick User
  Future kickUser(String playerName) async {
    final databaseRef = FirebaseDatabase.instance
        .ref()
        .child(FirebaseKeys.rooms)
        .child(roomId!);
    databaseRef.child('players').child(playerName).remove();
  }

  ////
  ///Check players exists
  Future checkAllPlayers() async {
    final databaseRef = await FirebaseDatabase.instance
        .ref()
        .child(FirebaseKeys.rooms)
        .child(roomId!);
  }
}

//Timer Dropdown
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

// Spy count dropdown
class SpyCountDropDown extends StatefulWidget {
  // const SPyCountDropDown({Key? key}) : super(key: key);
  final ValueChanged<String> onValueChanged;
  SpyCountDropDown(this.onValueChanged);

  @override
  State<SpyCountDropDown> createState() => _SpyCountDropDownState();
}

class _SpyCountDropDownState extends State<SpyCountDropDown> {
  var selectedCount = "1";
  var counts = [
    '1',
    '2',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      underline: SizedBox(),
      value: selectedCount,
      icon: const Icon(
        Icons.keyboard_arrow_down,
        size: 16,
      ),
      items: counts.map((items) {
        return DropdownMenuItem(
          value: items,
          child: Text(
            items,
            style: TextStyle(fontSize: 13),
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedCount = newValue.toString();
          widget.onValueChanged(newValue.toString());
        });
      },
    );
  }
}
