import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spyfall/custom_widgets/custombutton.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAlert extends StatelessWidget {
  // const AlertScreen({Key? key}) : super(key: key);
  // final VoidCallback cancelFn, okFn;
  var isAdmin;
  // final String alertMessage, alertTitle, buttonTitle;
  // AlertScreen(this.alertMessage, this.alertTitle, this.buttonTitle, this.okFn,
  //     this.cancelFn);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 249, 249, 249),
      content: Container(
        // height: screenHeight * 0.3,
        width: screenWidth * 0.9,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/sad48.png'),
            SizedBox(
              height: 10,
            ),
            Text(
              'App Update',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Please update to continue',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
            //Button
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SFButton('Cancel', screenHeight * 0.06, screenWidth * 0.25,
                      () {
                    SystemNavigator.pop();
                  }),
                  SFButton('Update', screenHeight * 0.06, screenWidth * 0.25,
                      () {
                    openURL(
                        "https://play.google.com/store/apps/details?id=com.inceptra.spyfall");
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> openURL(String _url) async {
    await launch(_url,
        forceSafariVC: true, forceWebView: true, enableJavaScript: true);
  }
}
