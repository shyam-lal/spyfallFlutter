import 'package:flutter/material.dart';

class LocationImage extends StatelessWidget {
  final String image;
  LocationImage(this.image);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        'assets/images/$image',
        width: screenWidth * 0.4,
        fit: BoxFit.cover,
      ),
    );
  }
}
