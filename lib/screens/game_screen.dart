import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spyfall/custom_widgets/countdown_timer.dart';
import 'package:spyfall/custom_widgets/custombutton.dart';

class GameScreen extends StatefulWidget {
  final String location, role;
  GameScreen(this.location, this.role);
  bool gameIsActive = true;
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              // color: Colors.white,
              decoration: const BoxDecoration(
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
                    children: const [
                      Text("Invite Code:"),
                    ],
                  ),
                  IconButton(onPressed: null, icon: Icon(Icons.menu))
                ],
              ),
            ),
            Container(
              width: screenWidth * 0.2,
              height: screenHeight * 0.05,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 72, 70, 70),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: CountDownTimer(
                  secondsRemaining: 90,
                  whenTimeExpires: () {
                    widget.gameIsActive = false;
                    print("========Expirewd========");
                  }),
            ),
            Text(widget.location),
            Text('Your role is ${widget.role}'),
            SFButton('Leave Room', screenHeight * 0.05, screenWidth * .3, () {
              leaveRoom(context);
            })
          ],
        ),
      ),
    );
  }

  void leaveRoom(BuildContext context) {
    Navigator.pop(context);
  }
}
