import 'package:flutter/material.dart';

Map<int, Color> _swatchOpacity = {
  50: Color.fromARGB(24, 250, 46, 46),
  100: Color.fromARGB(51, 125, 18, 18),
  200: Color.fromARGB(176, 243, 3, 3),
  300: Color.fromARGB(102, 0, 0, 0),
  400: Color.fromARGB(126, 240, 105, 105),
  500: Color.fromARGB(153, 170, 3, 3),
  600: Color.fromARGB(177, 96, 1, 1),
  700: Color.fromARGB(204, 244, 4, 4),
  800: Color.fromARGB(228, 146, 7, 7),
  900: Color.fromARGB(255, 164, 10, 10),
};

abstract class CustomColors {
  static Color customContrastColor = Colors.black;

  static MaterialColor customSwatchColor = MaterialColor(0xFFD3D3D3, _swatchOpacity);
}
