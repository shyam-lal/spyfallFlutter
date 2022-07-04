// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:spyfall/constants/strings.dart';
// import 'package:spyfall/models/room_model.dart';
// import 'package:spyfall/screens/lobby-screen.dart';

// class JoinRoomAlert extends StatelessWidget {
//   // const MyWidget({Key? key}) : super(key: key);
//   TextEditingController roomIdController = new TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: Color.fromARGB(255, 249, 249, 249),
//       content: Container(
//         decoration:
//             BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               // keyboardType: TextInputType.number,
//               textAlign: TextAlign.center,
//               controller: roomIdController,
//               decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20.0),
//                   ),
//                   fillColor: Colors.white,
//                   filled: true),
//             ),
//             //Button
//             Padding(
//               padding: EdgeInsets.only(top: 30),
//               child: ElevatedButton(
//                   style: ButtonStyle(
//                       foregroundColor:
//                           MaterialStateProperty.all<Color>(Colors.black),
//                       backgroundColor:
//                           MaterialStateProperty.all<Color>(Colors.black),
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(18.0),
//                               side: BorderSide(color: Colors.black)))),
//                   onPressed: () {
//                     print('oombikko myre');
//                     joinRoomTapped(context);
//                     // createTransactions(widget.expense, widget.income);
//                   },
//                   child: const Text(
//                     "Join Room",
//                     style: TextStyle(color: Colors.white),
//                   )),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   joinRoomTapped(BuildContext context) {
//     final roomRef = FirebaseDatabase.instance.ref().child(FirebaseKeys.rooms);
//     final roomId = roomIdController.text;
//     // final roomModel = RoomModel(roomId, 'dummy', {1: 'njan'}, false);
//     roomRef.child(roomId).child('players').child('njn').set('spy')
//         // .set({'hello': 'world'}).whenComplete(() {
//         // .set({'nee': 'spy'})
//         .whenComplete(() {
//       Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => LobbyScreen(roomId, false)));
//     });
//   }
// }
