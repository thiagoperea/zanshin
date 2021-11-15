import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._internal();

  static const TextStyle verySmallSize = TextStyle(fontSize: 16, fontFamily: "Nunito");
  static const TextStyle verySmallSizeBold = TextStyle(fontSize: 16, fontFamily: "Nunito", fontWeight: FontWeight.w700);

  static const TextStyle smallSize = TextStyle(fontSize: 18, fontFamily: "Nunito");
  static const TextStyle smallSizeBold = TextStyle(fontSize: 18, fontFamily: "Nunito", fontWeight: FontWeight.w700);

  static const TextStyle normalSize = TextStyle(fontSize: 20, fontFamily: "Nunito");
  static const TextStyle normalSizeBold = TextStyle(fontSize: 20, fontFamily: "Nunito", fontWeight: FontWeight.w700);
  static const TextStyle normalSizeSuperBold = TextStyle(fontSize: 20, fontFamily: "Nunito", fontWeight: FontWeight.w900);

  static const TextStyle bigSize = TextStyle(fontSize: 24, fontFamily: "Nunito");
  static const TextStyle bigSizeBold = TextStyle(fontSize: 24, fontFamily: "Nunito", fontWeight: FontWeight.w900);

  static const TextStyle extremeSize = TextStyle(fontSize: 32, fontFamily: "Nunito");
}
