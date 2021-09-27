import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zanshin/data/model/task.dart';
import 'package:zanshin/pages/pomodoro/pomodoro_cubit.dart';
import 'package:zanshin/pages/task_settings/task_settings_page.dart';
import 'package:zanshin/styles/app_colors.dart';
import 'package:zanshin/utility/platform_helper.dart';

class PomodoroControls extends StatelessWidget {
  const PomodoroControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PomodoroCubit, PomodoroState>(
      buildWhen: (previousState, currentState) => _shouldRebuild(previousState.state, currentState.state),
      builder: (context, state) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: 4),
          SmallButton(
            icon: FontAwesomeIcons.pen,
            onClick: state.hasTask() ? () => _onEditClick(context) : null,
          ),
          Spacer(),
          BigButton(
            icon: state.isPlaying() ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
            buttonColor: AppColors.getStateColor(state.state),
            onClick: state.hasTask() ? () => context.read<PomodoroCubit>().onPlayPauseClick() : null,
          ),
          Spacer(),
          SmallButton(
            icon: FontAwesomeIcons.stop,
            onClick: state.hasTask() ? () => context.read<PomodoroCubit>().stopTask() : null,
          ),
          Spacer(flex: 4),
        ],
      ),
    );
  }

  void _onEditClick(BuildContext context) {
    final Task? taskToUpdate = context.read<PomodoroCubit>().state.taskData;

    if (taskToUpdate != null) {
      context.read<PomodoroCubit>().stopTask();

      var route = MaterialPageRoute(builder: (context) => TaskSettingsPage(taskToUpdate));
      Navigator.of(context).push(route).then((wasEdited) {
        if (wasEdited) {
          context.read<PomodoroCubit>().updateTask(taskToUpdate);
        }
      });
    }
  }

  bool _shouldRebuild(PomodoroStates previous, PomodoroStates current) {
    return previous != current;
  }
}

class SmallButton extends StatelessWidget {
  final IconData icon;
  final Function? onClick;

  const SmallButton({Key? key, required this.icon, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // WARNING: workaround because sizes are different in platforms
    double size = 24;
    double padding = 16;

    if (PlatformHelper.isWeb() || PlatformHelper.isDesktop()) {
      padding += 12;
      size += 6;
    }

    return ElevatedButton(
      onPressed: onClick != null ? () => onClick?.call() : null,
      child: FaIcon(icon, size: size, color: Theme.of(context).colorScheme.onSurface),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: CircleBorder(
          side: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3), width: 2),
        ),
        padding: EdgeInsets.all(padding),
        primary: Colors.transparent,
      ),
    );
  }
}

class BigButton extends StatelessWidget {
  final IconData icon;
  final Color buttonColor;
  final Function? onClick;

  const BigButton({Key? key, required this.icon, required this.buttonColor, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // WARNING: workaround because sizes are different in platforms
    double size = 42;
    double padding = 30;

    if (PlatformHelper.isWeb() || PlatformHelper.isDesktop()) {
      padding += 12;
      size += 12;
    }

    return ElevatedButton(
      onPressed: onClick != null ? () => onClick?.call() : null,
      child: FaIcon(icon, size: size),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: EdgeInsets.all(padding),
        primary: buttonColor,
      ),
    );
  }
}
