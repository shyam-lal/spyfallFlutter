import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spyfall/constants/strings.dart';
import 'package:spyfall/custom_widgets/custombutton.dart';
import 'package:spyfall/models/room_model.dart';
import 'package:spyfall/providers/locations_provider.dart';
import 'package:spyfall/screens/game_screen.dart';

class LobbyScreen extends StatelessWidget {
  var currentLocation, playerRole;
  // const MyWidget({Key? key}) : super(key: key);
  final String roomId, userName;
  final bool isAdmin;
  Map<dynamic, dynamic> locations = {};
  var roomDetails;
  LobbyScreen(this.roomId, this.isAdmin, this.userName);

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
      backgroundColor: Colors.grey[200],
      body: Container(
        width: double.infinity,
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                // color: Colors.white,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // border: Border.all(color: Colors.black)
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
                        Text("Invite Code:"),
                        ElevatedButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: "roomId"));
                            },
                            child: Row(
                              children: [Text(roomId), Icon(Icons.copy)],
                            ))
                      ],
                    ),
                    IconButton(onPressed: null, icon: Icon(Icons.menu))
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                height: screenHeight * 0.6,
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
                              return Center(
                                  child: Container(
                                color: Colors.red,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.person),
                                    Text(players.keys.elementAt(index)),
                                    IconButton(
                                        onPressed: null,
                                        icon: Icon(Icons.close))
                                  ],
                                ),
                              ));
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
                  ? SFButton(
                      'Start Game', screenHeight * 0.08, screenWidth * .5, () {
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

    databaseRef.child('isplaying').set(true);
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

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => GameScreen(currentLocation, playerRole)));
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
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => GameScreen(currentLocation, playerRole)));
      }
    });
  }
}
