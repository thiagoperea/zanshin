import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:zanshin/pages/pomodoro/pomodoro_cubit.dart';
import 'package:zanshin/styles/app_colors.dart';
import 'package:zanshin/styles/app_text_styles.dart';

class PomodoroTimer extends StatelessWidget {
  const PomodoroTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final double radiusSize = min(screenSize.width * 0.6, screenSize.height * 0.6);
    final double lineWidth = radiusSize * 0.05;
    final fontSize = radiusSize * 0.18;

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
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
            Text(
              _getStateDescription(state.state),
              style: AppTextStyles.smallSizeBold,
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
