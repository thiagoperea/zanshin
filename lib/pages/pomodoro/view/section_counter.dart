import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanshin/pages/pomodoro/pomodoro_cubit.dart';
import 'package:zanshin/styles/app_colors.dart';

class SectionCounter extends StatelessWidget {
  const SectionCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PomodoroCubit, PomodoroState>(
      buildWhen: (previousState, currentState) => currentState.state == PomodoroStates.stop || previousState.state != currentState.state,
      builder: (context, state) {
        int sectionCount = state.taskData?.sections ?? 0;
        int currentSection = state.currentSection;

        Color stateColor = AppColors.getStateColor(state.state);

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(sectionCount, (idx) {
            MarkState state;
            if (idx < (currentSection - 1)) {
              state = MarkState.filled;
            } else if (idx == (currentSection - 1)) {
              state = MarkState.actual;
            } else {
              state = MarkState.notFilled;
            }

            return SectionMark(
              selectionColor: stateColor,
              state: state,
              isLast: idx == (sectionCount - 1),
            );
          }),
        );
      },
    );
  }
}

enum MarkState { filled, notFilled, actual }

class SectionMark extends StatelessWidget {
  final Color selectionColor;
  final MarkState state;
  final bool isLast;

  const SectionMark({
    Key? key,
    required this.selectionColor,
    required this.state,
    required this.isLast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color surfaceColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.2);

    Color activeColor;
    Color backgroundColor;

    if (state == MarkState.filled) {
      activeColor = selectionColor;
      backgroundColor = selectionColor;
    } else if (state == MarkState.actual) {
      activeColor = selectionColor;
      backgroundColor = surfaceColor;
    } else {
      activeColor = surfaceColor;
      backgroundColor = surfaceColor;
    }

    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            border: state == MarkState.actual ? Border.all(color: activeColor, width: 3) : null,
            color: state == MarkState.actual ? backgroundColor : activeColor,
            shape: BoxShape.circle,
          ),
        ),
        Visibility(
          child: Container(width: 12, height: 3, color: backgroundColor),
          visible: !isLast,
        ),
      ],
    );
  }
}
