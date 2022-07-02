import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:spyfall/constants/strings.dart';
import 'package:spyfall/screens/game_screen.dart';

class LobbyScreen extends StatefulWidget {
  final String roomId;
  final bool isAdmin;
  LobbyScreen(this.roomId, this.isAdmin);

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  List<String> players = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAdmin) {
      listenForStarting(context);
    }
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.roomId),

              StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .ref()
                      .child('rooms')
                      .child(widget.roomId)
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

              // ListView.separated(
              //   shrinkWrap: true,
              //   // physics: ClampingScrollPhysics(),
              //   separatorBuilder: (BuildContext context, int index) {
              //     return SizedBox(height: 20);
              //   },
              //   itemCount: players.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     return Text(players[index]);
              //   },
              // ),

              widget.isAdmin
                  ? ElevatedButton(
                      onPressed: startGame, child: Text('Start Game'))
                  : SizedBox()
            ]),
      ),
    );
  }

  void startGame() {
    final databaseRef = FirebaseDatabase.instance.ref();

    databaseRef
        .child(FirebaseKeys.rooms)
        .child(widget.roomId)
        .child('isplaying')
        .set(true)
        .whenComplete(() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => GameScreen()));
    });
  }

  void listenForStarting(BuildContext context) {
    final databaseRef = FirebaseDatabase.instance.ref();
    final sub = databaseRef
        .child(FirebaseKeys.rooms)
        .child(widget.roomId)
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

  Future getNotifications() async {
    final databaseRef =
        FirebaseDatabase.instance.ref(); //database reference object

    databaseRef
        .child(FirebaseKeys.rooms)
        .child(widget.roomId)
        .child('players')
        .onValue
        .listen((event) {
      final data = event.snapshot.value as List<String>;
      setState(() {
        players = data;
      });
    });
  }
}
