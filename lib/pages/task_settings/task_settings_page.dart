import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanshin/common_widgets/simple_loading_dialog.dart';
import 'package:zanshin/common_widgets/single_input_dialog.dart';
import 'package:zanshin/common_widgets/title_bar.dart';
import 'package:zanshin/data/model/task.dart';
import 'package:zanshin/pages/app_settings/app_settings_page.dart';
import 'package:zanshin/pages/home_page.dart';
import 'package:zanshin/pages/pomodoro/pomodoro_cubit.dart';
import 'package:zanshin/pages/task_settings/task_settings_cubit.dart';
import 'package:zanshin/styles/app_colors.dart';
import 'package:zanshin/styles/app_text_styles.dart';
import 'package:zanshin/utility/time_extensions.dart';

class TaskSettingsPage extends StatefulWidget {
  static const String route = '/task-settings';
  final Task task;

  const TaskSettingsPage(this.task, {Key? key}) : super(key: key);

  @override
  State<TaskSettingsPage> createState() => _TaskSettingsPageState();
}

class _TaskSettingsPageState extends State<TaskSettingsPage> {
  int _workTime = 1;
  int _shortBreak = 1;
  int _longBreak = 1;
  int _sectionCount = 1;

  late final TaskSettingsCubit _cubit;

  @override
  void initState() {
    _cubit = TaskSettingsCubit(widget.task);

    _workTime = widget.task.workTimeSecs.secToMin();
    _shortBreak = widget.task.shortBreakSecs.secToMin();
    _longBreak = widget.task.longBreakSecs.secToMin();
    _sectionCount = widget.task.sections;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskSettingsCubit>(
      create: (context) => _cubit,
      child: BlocConsumer<TaskSettingsCubit, TaskSettingsState>(
        listener: (context, state) => _onStateChanged(context, state),
        builder: (context, state) => Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                TitleBar(
                  title: "Ajustes",
                  onBackClick: () => _updateTask(context),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text("Descrição da tarefa", style: AppTextStyles.smallSize),
                          subtitle: Text(state.task.description, style: AppTextStyles.smallSizeBold),
                          onTap: () => _onDescriptionClick(context),
                        ),
                        SizedBox(height: 8),
                        const SettingsDivider(),
                        ListTile(
                          title: Text("Tempo de trabalho", style: AppTextStyles.smallSize, textAlign: TextAlign.center),
                          subtitle: Text("$_workTime min", style: AppTextStyles.smallSizeBold, textAlign: TextAlign.center),
                        ),
                        _createSlider(_workTime, 1, 120, "min", AppColors.getStateColor(PomodoroStates.work), (newValue) {
                          setState(() => _workTime = newValue);
                        }),
                        const SettingsDivider(),
                        ListTile(
                          title: Text("Descanso curto", style: AppTextStyles.smallSize, textAlign: TextAlign.center),
                          subtitle: Text("$_shortBreak min", style: AppTextStyles.smallSizeBold, textAlign: TextAlign.center),
                        ),
                        _createSlider(_shortBreak, 1, 60, "min", AppColors.getStateColor(PomodoroStates.shortBreak), (newValue) {
                          setState(() => _shortBreak = newValue);
                        }),
                        const SettingsDivider(),
                        ListTile(
                          title: Text("Descanso longo", style: AppTextStyles.smallSize, textAlign: TextAlign.center),
                          subtitle: Text("$_longBreak min", style: AppTextStyles.smallSizeBold, textAlign: TextAlign.center),
                        ),
                        _createSlider(_longBreak, 1, 90, "min", AppColors.getStateColor(PomodoroStates.longBreak), (newValue) {
                          setState(() => _longBreak = newValue);
                        }),
                        const SettingsDivider(),
                        ListTile(
                          title: Text("Sessões", style: AppTextStyles.smallSize, textAlign: TextAlign.center),
                          subtitle: Text("$_sectionCount", style: AppTextStyles.smallSizeBold, textAlign: TextAlign.center),
                        ),
                        _createSlider(_sectionCount, 1, 10, "", null, (newValue) {
                          setState(() => _sectionCount = newValue);
                        }),
                        const SettingsDivider(),
                      ],
                    ),
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
      Navigator.of(context).popUntil((route) => route.settings.name == HomePage.route);
    }
  }

  void _onDescriptionClick(BuildContext context) async {
    String? newValue = await showDialog(
      context: context,
      builder: (context) => SingleInputDialog(
        title: "Descrição da tarefa",
        inputLabel: "Novo valor",
        textInputType: TextInputType.text,
        confirmButtonLabel: "Salvar",
        onConfirmClick: (inputValue) => Navigator.pop(context, inputValue),
      ),
    );

    _cubit.setDescription(newValue);
  }

  void _updateTask(BuildContext context) {
    _cubit.updateTask(_workTime, _shortBreak, _longBreak, _sectionCount);
  }

  Slider _createSlider(
    int value,
    int min,
    int max,
    String labelSuffix,
    Color? sliderColor,
    Function(int) onChanged,
  ) {
    return Slider(
      value: value.roundToDouble(),
      min: min.roundToDouble(),
      max: max.roundToDouble(),
      divisions: (max - min).round(),
      label: labelSuffix.isNotEmpty ? "$value $labelSuffix" : "$value",
      activeColor: sliderColor,
      onChanged: (double newValue) => onChanged(newValue.round()),
    );
  }
}
