import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanshin/data/app_cache.dart';
import 'package:zanshin/data/model/task.dart';
import 'package:zanshin/pages/app_settings/app_settings_cubit.dart';
import 'package:zanshin/pages/pomodoro/pomodoro_cubit.dart';
import 'package:zanshin/pages/pomodoro/view/button_controls.dart';
import 'package:zanshin/pages/pomodoro/view/pomodoro_timer.dart';
import 'package:zanshin/pages/pomodoro/view/section_counter.dart';
import 'package:zanshin/styles/app_text_styles.dart';

class PomodoroPage extends StatefulWidget {
  final Task? task;

  const PomodoroPage({Key? key, required this.task}) : super(key: key);

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> with WidgetsBindingObserver {
  late final PomodoroCubit cubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this); // Lifecycle can be observed using WidgetsBindingObserver!
    if (widget.task != null) {
      int selectedAlarm = context.read<AppSettingsCubit>().state.selectedAlarm;
      cubit = PomodoroCubit.fromTask(widget.task!, selectedAlarm);
    } else {
      cubit = PomodoroCubit.empty();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    cubit.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    AppCache().isInForeground = state == AppLifecycleState.resumed;

    if (state == AppLifecycleState.paused) {
      cubit.stopTask();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PomodoroCubit>(
      create: (context) => cubit,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              _getHeader(widget.task),
              const PomodoroTimer(),
              const SectionCounter(),
              const PomodoroControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getHeader(Task? selectedTask) {
    if (selectedTask != null) {
      return Column(
        children: [
          const Text("TAREFA ATUAL", style: AppTextStyles.verySmallSize),
          const SizedBox(height: 4),
          Text(selectedTask.description, style: AppTextStyles.bigSizeBold),
        ],
      );
    } else {
      return const Center(
        child: Text("selecione uma tarefa", style: AppTextStyles.normalSizeBold),
      );
    }
  }
}
