import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanshin/data/model/task.dart';
import 'package:zanshin/pages/pomodoro/pomodoro_cubit.dart';
import 'package:zanshin/pages/pomodoro/view/button_controls.dart';
import 'package:zanshin/pages/pomodoro/view/pomodoro_timer.dart';
import 'package:zanshin/pages/pomodoro/view/section_counter.dart';
import 'package:zanshin/styles/app_text_styles.dart';

class PomodoroPage extends StatelessWidget with WidgetsBindingObserver {
  const PomodoroPage() : super();

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance?.addObserver(this); // Lifecycle can be observed using WidgetsBindingObserver!
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance?.removeObserver(this);
  //   super.dispose();
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // cubit.stopTask(); TODO: stop task??
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            const PomodoroHeader(),
            const PomodoroTimer(),
            const SectionCounter(),
            const PomodoroControls(),
          ],
        ),
      ),
    );
  }
}

class PomodoroHeader extends StatelessWidget {
  const PomodoroHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PomodoroCubit, PomodoroState>(
      builder: (context, state) {
        Task? taskData = state.taskData;

        if (taskData != null) {
          return Column(
            children: [
              const Text("TAREFA ATUAL", style: AppTextStyles.verySmallSize),
              const SizedBox(height: 4),
              Text(taskData.description, style: AppTextStyles.bigSizeBold),
            ],
          );
        } else {
          return const Center(
            child: Text("selecione uma tarefa", style: AppTextStyles.normalSizeBold),
          );
        }
      },
    );
  }
}
