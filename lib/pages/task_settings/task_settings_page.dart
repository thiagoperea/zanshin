import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanshin/common_widgets/simple_loading_dialog.dart';
import 'package:zanshin/common_widgets/single_input_dialog.dart';
import 'package:zanshin/common_widgets/title_bar.dart';
import 'package:zanshin/data/model/task.dart';
import 'package:zanshin/pages/app_settings/app_settings_page.dart';
import 'package:zanshin/pages/task_settings/task_settings_cubit.dart';
import 'package:zanshin/utility/time_extensions.dart';

class TaskSettingsPage extends StatelessWidget {
  final Task task;

  const TaskSettingsPage(this.task, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskSettingsCubit>(
      create: (context) => TaskSettingsCubit(task),
      child: BlocConsumer<TaskSettingsCubit, TaskSettingsState>(
        listener: (context, state) => _onStateChanged(context, state),
        builder: (context, state) => Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                TitleBar(
                  title: "Ajustes",
                  onBackClick: () => Navigator.of(context).pop(state.wasUpdated()),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SettingsItem(
                        "Tempo de trabalho",
                        "${state.task.workTimeSecs.secToMin().toInt()} min",
                        () => _onWorkTimeClick(context),
                      ),
                      const SettingsDivider(),
                      SettingsItem(
                        "Descanso curto",
                        "${state.task.shortBreakSecs.secToMin().toInt()} min",
                        () => _onShortBreakClick(context),
                      ),
                      const SettingsDivider(),
                      SettingsItem(
                        "Descanso longo",
                        "${state.task.longBreakSecs.secToMin().toInt()} min",
                        () => _onLongBreakClick(context),
                      ),
                      const SettingsDivider(),
                      SettingsItem(
                        "Sessões de trabalho",
                        state.task.sections.toString(),
                        () => _onSessionsClick(context),
                      ),
                      const SettingsDivider(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onStateChanged(BuildContext context, TaskSettingsState state) {
    if (state.state == TaskSettingsStates.loading) {
      showDialog(
        context: context,
        builder: (context) => const SimpleLoadingDialog(loadingText: "Salvando ajustes..."),
      );
    }

    if (state.state == TaskSettingsStates.success || state.state == TaskSettingsStates.error) {
      Navigator.pop(context);
    }
  }

  void _onWorkTimeClick(BuildContext context) async {
    String newValue = await showDialog(
      context: context,
      builder: (context) => SingleInputDialog(
        title: "Tempo de trabalho",
        inputLabel: "Novo valor",
        textInputType: TextInputType.number,
        confirmButtonLabel: "Salvar",
        onConfirmClick: (inputValue) => Navigator.pop(context, inputValue),
      ),
    );

    context.read<TaskSettingsCubit>().updateWorkTime(newValue);
  }

  void _onShortBreakClick(BuildContext context) async {
    String newValue = await showDialog(
      context: context,
      builder: (context) => SingleInputDialog(
        title: "Descanso curto",
        inputLabel: "Novo valor",
        textInputType: TextInputType.number,
        confirmButtonLabel: "Salvar",
        onConfirmClick: (inputValue) => Navigator.pop(context, inputValue),
      ),
    );

    context.read<TaskSettingsCubit>().updateShortBreak(newValue);
  }

  void _onLongBreakClick(BuildContext context) async {
    String newValue = await showDialog(
      context: context,
      builder: (context) => SingleInputDialog(
        title: "Descanso longo",
        inputLabel: "Novo valor",
        textInputType: TextInputType.number,
        confirmButtonLabel: "Salvar",
        onConfirmClick: (inputValue) => Navigator.pop(context, inputValue),
      ),
    );

    context.read<TaskSettingsCubit>().updateLongBreak(newValue);
  }

  void _onSessionsClick(BuildContext context) async {
    String newValue = await showDialog(
      context: context,
      builder: (context) => SingleInputDialog(
        title: "Sessões de trabalho",
        inputLabel: "Novo valor",
        textInputType: TextInputType.number,
        confirmButtonLabel: "Salvar",
        onConfirmClick: (inputValue) => Navigator.pop(context, inputValue),
      ),
    );

    context.read<TaskSettingsCubit>().updateSectionCount(newValue);
  }
}
