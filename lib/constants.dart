import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

Color DarkBackgroundColor = HexColor("#000000");
Color PrimaryColor = HexColor("#2196f3");
Color primaryDark = HexColor("#0069c0");
Color primaryLight = HexColor("#e6ffff");
Color secondryColor = HexColor("#3d5afe");
Color secondryLight = HexColor("#8187ff");
Color secondryDark = HexColor("#0031ca");
Color amberColor = HexColor("#ffb300");
