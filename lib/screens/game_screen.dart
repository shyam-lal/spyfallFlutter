import 'package:flutter/material.dart';
import 'package:spyfall/custom_widgets/custombutton.dart';

class GameScreen extends StatelessWidget {
  // Animation<int> animation;
  final String location, role;
  GameScreen(this.location, this.role);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(location),
            Text('Your role is $role'),
            // ElevatedButton(
            //     onPressed: () {
            //       leaveRoom(context);
            //     },
            //     child: const Text('Leave Room'))
            SFButton('Start Game', () {
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

// import 'dart:async';

// import 'package:flutter/src/widgets/framework.dart';

// import 'package:flutter/src/foundation/key.dart';

// Timer _timer;
// int _start = 10;

// class MyWidget extends StatelessWidget {
//   const MyWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     void startTimer() {
//       const oneSec = const Duration(seconds: 1);
//       _timer = new Timer.periodic(
//         oneSec,
//         (Timer timer) {
//           if (_start == 0) {
//             setState(() {
//               timer.cancel();
//             });
//           } else {
//             setState(() {
//               _start--;
//             });
//           }
//         },
//       );
//     }

//     @override
//     void dispose() {
//       _timer.cancel();
//       super.dispose();
//     }

//     Widget build(BuildContext context) {
//       return new Scaffold(
//         appBar: AppBar(title: Text("Timer test")),
//         body: Column(
//           children: <Widget>[
//             RaisedButton(
//               onPressed: () {
//                 startTimer();
//               },
//               child: Text("start"),
//             ),
//             Text("$_start")
//           ],
//         ),
//       );
//     }
//   }
// }
