import 'package:flutter/material.dart';

// Define a common ButtonStyle
final ButtonStyle myButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  ),
  shape: MaterialStateProperty.all<OutlinedBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
);