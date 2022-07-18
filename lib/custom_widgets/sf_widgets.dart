import 'package:flutter/material.dart';

class SFSpace extends StatelessWidget {
  final double height, width;
  SFSpace(this.height, this.width);
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: screenHeight * height,
      width: screenWidth * width,
    );
  }
}
