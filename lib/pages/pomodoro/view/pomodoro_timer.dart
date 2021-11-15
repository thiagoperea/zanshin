import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:zanshin/pages/pomodoro/pomodoro_cubit.dart';
import 'package:zanshin/styles/app_colors.dart';

class PomodoroTimer extends StatelessWidget {
  const PomodoroTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final double radiusSize = min(screenSize.width * 0.5, screenSize.height * 0.5);
    final double lineWidth = radiusSize * 0.05;
    final pomodoroTextSize = radiusSize * 0.18;
    final descriptionTextSize = radiusSize * 0.09;

    return BlocBuilder<PomodoroCubit, PomodoroState>(
      builder: (context, state) => CircularPercentIndicator(
        radius: radiusSize,
        lineWidth: lineWidth,
        percent: state.progressRemaining,
        animation: true,
        animateFromLastPercent: true,
        animationDuration: 1000,
        curve: Curves.decelerate,
        circularStrokeCap: CircularStrokeCap.round,
        center: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _getFormattedTime(state.timeRemaining),
              style: TextStyle(fontSize: pomodoroTextSize, fontFamily: "Nunito", fontWeight: FontWeight.bold),
            ),
            Text(
              _getStateDescription(state.state),
              style: TextStyle(fontSize: descriptionTextSize, fontFamily: "Nunito", fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.grey.shade400,
        progressColor: AppColors.getStateColor(state.state),
      ),
    );
  }

  String _getFormattedTime(int timeRemaining) => Duration(seconds: timeRemaining).toString().split('.').first.padLeft(8, "0");

  String _getStateDescription(PomodoroStates state) {
    switch (state) {
      case PomodoroStates.work:
        return "Trabalho";
      case PomodoroStates.pause:
      case PomodoroStates.stop:
        return "Parado";
      case PomodoroStates.shortBreak:
        return "Descanso curto";
      case PomodoroStates.longBreak:
        return "Descanso longo";
    }
  }
}
