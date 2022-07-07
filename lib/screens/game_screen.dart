import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
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
            ElevatedButton(
                onPressed: () {
                  leaveRoom(context);
                },
                child: const Text('Leave Room'))
          ],
        ),
      ),
    );
  }

  void leaveRoom(BuildContext context) {
    Navigator.pop(context);
  }
}
