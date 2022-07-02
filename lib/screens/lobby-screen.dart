import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spyfall/constants/strings.dart';
import 'package:spyfall/models/room_model.dart';
import 'package:spyfall/providers/locations_provider.dart';
import 'package:spyfall/screens/game_screen.dart';

class LobbyScreen extends StatelessWidget {
  // const MyWidget({Key? key}) : super(key: key);
  final String roomId;
  final bool isAdmin;
  List<String> locations = [];
  var roomDetails;
  LobbyScreen(this.roomId, this.isAdmin);

  @override
  Widget build(BuildContext context) {
    print('---------------LobbyScreen--------------');
    if (isAdmin) {
      listenForStarting(context);
    }
    locations = context
        .watch<LocationProvider>()
        .locations
        .map((e) => e.toString())
        .toList();
    if (locations.isEmpty) {
      context.read<LocationProvider>().getLocations();
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(roomId),
              StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .ref()
                      .child('rooms')
                      .child(roomId)
                      .child('players')
                      .onValue
                      .asBroadcastStream(),
                  // .asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      // var databaseEvent = snapshot
                      //     .value; // 👈 Get the DatabaseEvent from the AsyncSnapshot
                      // var databaseSnapshot = databaseEvent
                      //     .snapshot; // 👈 Get the DataSnapshot from the DatabaseEvent
                      print('Snapshot: ${snapshot.data.toString()}');
                      DatabaseEvent event = snapshot.data as DatabaseEvent;
                      final players =
                          event.snapshot.value as Map<dynamic, dynamic>;
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: players.length,
                          itemBuilder: (context, index) {
                            return Text(players.keys.elementAt(index));
                          });
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
              isAdmin
                  ? ElevatedButton(
                      onPressed: () {
                        startGame(context);
                      },
                      child: Text('Start Game'))
                  : SizedBox()
            ]),
      ),
    );
  }

  Future fetchRoomDetails() async {
    final databaseRef =
        FirebaseDatabase.instance.ref().child(FirebaseKeys.rooms).child(roomId);

    databaseRef.once().then((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      roomDetails = RoomModel.fromJson(data);
      final players = roomDetails.players as Map<dynamic, dynamic>;
      final randInt = Random().nextInt(players.keys.length);
      final spyPlayer = players.keys.elementAt(randInt);
      // databaseRef.child('players').child(players[spyPlayer]).set('spy');
      databaseRef.child('players').set({spyPlayer: 'spy'});
      // for (var player in players.keys) {
      //         databaseRef.child('players').child(player).set()
      // }
      // databaseRef.child('players').;
    });
  }

  Future startGame(BuildContext context) async {
    fetchRoomDetails();
    final databaseRef =
        FirebaseDatabase.instance.ref().child(FirebaseKeys.rooms).child(roomId);

    final location = (locations..shuffle()).first;

    await databaseRef.child('location').set(location);

    databaseRef.child('isplaying').set(true).whenComplete(() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => GameScreen()));
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
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => GameScreen()));
      }
    });
  }
}
