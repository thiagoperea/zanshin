import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zanshin/pages/pomodoro/pomodoro_cubit.dart';

class AppColors {
  AppColors._internal();

  static late Color _lastButtonColor = Colors.transparent;

  static const Color darkBackground = Color(0xFF292A2E);
  static const Color darkPrimary = Color(0xFF6C4EB3);
  static const Color darkAccent = Color(0xFF664EFF);

  static const Color primary = Color(0xFF7393DD);

  static Color getStateColor(PomodoroStates state) {
    Color buttonColor = _lastButtonColor;

    switch (state) {
      case PomodoroStates.work:
        buttonColor = Colors.deepOrange;
        break;
      case PomodoroStates.stop:
        buttonColor = primary;
        break;
      case PomodoroStates.shortBreak:
        buttonColor = Colors.green;
        break;
      case PomodoroStates.longBreak:
        buttonColor = Colors.deepPurple;
        break;
      case PomodoroStates.pause:
        break;
    }

    _lastButtonColor = buttonColor;
    return buttonColor;
  }
}
