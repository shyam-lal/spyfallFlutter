import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: createRoomTapped, child: Text("CREATE ROOM")),
            ElevatedButton(onPressed: joinRoomTapped, child: Text("JOIN ROOM"))
          ],
        ),
      ),
    );
  }

  createRoomTapped() {}

  joinRoomTapped() {}
}
