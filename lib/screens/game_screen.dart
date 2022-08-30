import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spyfall/constants/strings.dart';
import 'package:spyfall/custom_widgets/alert.dart';
import 'package:spyfall/custom_widgets/countdown_timer.dart';
import 'package:spyfall/custom_widgets/custombutton.dart';
import 'package:spyfall/custom_widgets/exit_alert.dart';
import 'package:spyfall/custom_widgets/sf_images.dart';
import 'package:spyfall/custom_widgets/sf_widgets.dart';
import 'package:spyfall/providers/locations_provider.dart';
import 'package:spyfall/providers/user_provider.dart';

class GameScreen extends StatefulWidget {
  final int countdownTime;
  final String location, role, roomId;
  GameScreen(this.location, this.role, this.countdownTime, this.roomId);
  bool gameIsActive = true;
  @override
  State<GameScreen> createState() => _GameScreenState();
  var locationImages = {
    'bank.png': false,
    'beach.png': false,
    'circus.png': false,
    'hotel.png': false,
    'restaurant.png': false,
    'school.png': false
  };
}

class _GameScreenState extends State<GameScreen> {
  var isAdmin;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    isAdmin = context.watch<UserProvider>().isAdmin;
    return WillPopScope(
      onWillPop: () {
        showDialog(
            context: context,
            builder: (BuildContext buildContext) {
              return ExitAlert(widget.roomId, 1);
            });
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  height: screenHeight * 0.12,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const IconButton(
                          onPressed: null, icon: Icon(Icons.person)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          // Text("Invite Code:"),
                        ],
                      ),
                      const IconButton(onPressed: null, icon: Icon(Icons.menu))
                    ],
                  ),
                ),
                SFSpace(0.05, 0),
                Container(
                  width: screenWidth * 0.2,
                  height: screenHeight * 0.05,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 72, 70, 70),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: CountDownTimer(
                      secondsRemaining: (widget.countdownTime * 60),
                      whenTimeExpires: () {
                        widget.gameIsActive = false;
                        showDialog(
                            context: context,
                            builder: (BuildContext buildContext) {
                              return AlertMessage();
                            });
                      }),
                ),
                SFSpace(0.02, 0),
                Text("The location is ${widget.location}"),
                SFSpace(0.02, 0),
                Text('Your are the ${widget.role}'),
                SFSpace(0.02, 0),
                SFButton('Restart Round', screenHeight * 0.05, screenWidth * .3,
                    () {
                  restartRound(context);
                }),
                SFSpace(0.05, 0),
                const Text(
                  "Locations: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Text(
                  "Tap to mark off locations",
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.grey),
                ),
                ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          LocationWidget(2 * index),
                          LocationWidget((2 * index) + 1)
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 20);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void restartRound(BuildContext context) async {
    final databaseRef = await FirebaseDatabase.instance
        .ref()
        .child(FirebaseKeys.rooms)
        .child(widget.roomId);
    databaseRef.child('isPlaying').set(false).then((value) {
      Navigator.pop(context);
    });

    Navigator.pop(context);
  }
}

class LocationWidget extends StatelessWidget {
  final int index;
  LocationWidget(this.index);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final locationImages = context.watch<LocationProvider>().locationImages;
    return GestureDetector(
      onTap: () {
        context
            .read<LocationProvider>()
            .toggleSelection(locationImages.keys.elementAt(index));
      },
      child: Stack(
        children: [
          LocationImage(locationImages.keys.elementAt(index)),
          locationImages.values.elementAt(index)
              ? Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(149, 255, 29, 29),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  height: screenHeight * 0.14,
                  width: screenWidth * 0.4,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
