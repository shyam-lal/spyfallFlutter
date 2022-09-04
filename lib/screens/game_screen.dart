import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spyfall/constants/strings.dart';
import 'package:spyfall/custom_widgets/ad-widgets.dart';
import 'package:spyfall/custom_widgets/alert.dart';
import 'package:spyfall/custom_widgets/countdown_timer.dart';
import 'package:spyfall/custom_widgets/custombutton.dart';
import 'package:spyfall/custom_widgets/exit_alert.dart';
import 'package:spyfall/custom_widgets/sf_images.dart';
import 'package:spyfall/custom_widgets/sf_widgets.dart';
import 'package:spyfall/managers/g_ads_manager.dart';
import 'package:spyfall/providers/locations_provider.dart';
import 'package:spyfall/providers/room_provider.dart';
import 'package:spyfall/providers/user_provider.dart';

class GameScreen extends StatefulWidget {
  // GameScreen(this.location, this.role, this.countdownTime, this.roomId);
  bool gameIsActive = true;
  @override
  State<GameScreen> createState() => _GameScreenState();
  // var locationImages = {
  //   'bank.png': false,
  //   'beach.png': false,
  //   'circus.png': false,
  //   'hotel.png': false,
  //   'restaurant.png': false,
  //   'school.png': false
  // };
}

class _GameScreenState extends State<GameScreen> {
  var first = false;
  int? countdownTime;
  String? location, role, roomId;
  var isAdmin;
  @override
  Widget build(BuildContext context) {
    print("===========================");
    print('=================Game Screen');
    //Routes
    final routes =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    countdownTime = routes['time'] as int;
    location = routes['location'].toString();
    role = routes['role'].toString();
    roomId = routes['id'].toString();
    //

    if (!first) {
      first = true;
      listenForEnding(context);
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    isAdmin = context.watch<UserProvider>().isAdmin;
    return WillPopScope(
      onWillPop: () {
        showDialog(
            context: context,
            builder: (BuildContext buildContext) {
              return ExitAlert(roomId!, 1);
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
                      IconButton(
                          onPressed: () {
                            if (isAdmin) {
                              context.read<RoomProvider>().deleteRoom(roomId!);
                            }

                            Navigator.popUntil(
                                context, ModalRoute.withName('/'));
                            // Navigator.popunti
                          },
                          icon: Icon(Icons.person)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          // Text("Invite Code:"),
                        ],
                      ),
                      // const IconButton(onPressed: null, icon: Icon(Icons.menu))
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
                      secondsRemaining: (countdownTime! * 60),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (role == 'spy')
                          ? 'Find out the location without revealing yourself'
                          : "The location is ",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    (role != 'spy')
                        ? Text(
                            location.toString(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue[900]),
                          )
                        : SizedBox()
                  ],
                ),
                SFSpace(0.02, 0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You are the ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      role.toString().toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 19,
                          color: Colors.blue[900]),
                    )
                  ],
                ),
                SFSpace(0.02, 0),
                isAdmin
                    ? SFButton(
                        'Restart Round', screenHeight * 0.05, screenWidth * .3,
                        () {
                        restartRound(context);
                      })
                    : SizedBox(),
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
                    itemCount: 6,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              LocationWidget(2 * index),
                              LocationWidget((2 * index) + 1)
                            ],
                          ),
                          (index == 1)
                              ? SFBannerAd(AdManager.gameScreenBannerAd1)
                              : (index == 5)
                                  ? SFBannerAd(AdManager.gameScreenBannerAd2)
                                  : SizedBox()
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
        .child(roomId!);
    databaseRef.child('isplaying').set(false).then((value) {
      Navigator.popUntil(context, ModalRoute.withName('/lobby'));
      // Navigator.pop(context);
    });

    // Navigator.pop(context);
    // Navigator.popUntil(context, ModalRoute.withName('/lobby'));
  }

  void listenForEnding(BuildContext context) {
    final databaseRef = FirebaseDatabase.instance.ref();
    final sub = databaseRef
        .child(FirebaseKeys.rooms)
        .child(roomId!)
        .child('isplaying')
        .onValue
        .listen((event) {
      final value = event.snapshot.value as bool;
      if (!value) {
        Navigator.popUntil(context, ModalRoute.withName('/lobby'));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // listenForEnding(context);
    context.read<LocationImageProvider>().resetImage();
  }
}

class LocationWidget extends StatelessWidget {
  final int index;
  LocationWidget(this.index);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final locationImages =
        context.watch<LocationImageProvider>().locationImages;
    return GestureDetector(
      onTap: () {
        context
            .read<LocationImageProvider>()
            .toggleSelection(locationImages.keys.elementAt(index));
      },
      child: IntrinsicHeight(
        child: Stack(
          children: [
            LocationImage(locationImages.keys.elementAt(index)),
            locationImages.values.elementAt(index)
                ? Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(149, 255, 29, 29),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    // height: screenHeight * 0.14,
                    width: screenWidth * 0.4,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
