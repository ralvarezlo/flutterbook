import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class MiscFunctionality {
  static Color toColor(String colorStr) {
    Color color;
    switch (colorStr) {
      case "red" : color = Colors.red; break;
      case "green" : color = Colors.green; break;
      case "blue" : color = Colors.blue; break;
      case "yellow" : color = Colors.yellow; break;
      case "grey" : color = Colors.grey; break;
      case "purple" : color = Colors.purple; break;
    }
    return color;
  }
}