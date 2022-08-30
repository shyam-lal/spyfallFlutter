import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingAlert extends StatelessWidget {
  // const AlertScreen({Key? key}) : super(key: key);
  var isAdmin;
  final String alertMessage;
  LoadingAlert(this.alertMessage);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 249, 249, 249),
      content: Container(
        height: screenHeight * 0.3,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset('assets/images/sad48.png'),
            SizedBox(
                height: screenWidth * 0.15,
                width: screenWidth * 0.15,
                child: CircularProgressIndicator(
                  color: Colors.black,
                )),
            // GWSpace(screenHeight * 0.1, screenWidth * 0.8),
            SizedBox(
              height: screenHeight * 0.1,
            ),
            Text(
              alertMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
