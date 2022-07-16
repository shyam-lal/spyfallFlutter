import 'package:flutter/material.dart';

class SFButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height, width;
  SFButton(this.text, this.height, this.width, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      // width: MediaQuery.of(context).size.width * 0.5,
      child: Center(
        child: MaterialButton(
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 3.0)),
    );
  }
}
