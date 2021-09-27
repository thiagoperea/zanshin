import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanshin/common_widgets/simple_loading_dialog.dart';
import 'package:zanshin/common_widgets/title_bar.dart';
import 'package:zanshin/pages/app_settings/app_settings_cubit.dart';
import 'package:zanshin/styles/app_colors.dart';
import 'package:zanshin/styles/app_text_styles.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppSettingsCubit, AppSettings>(
      listenWhen: (previous, current) => previous.isLoading != current.isLoading,
      listener: (context, state) => _onStateChanged(context, state),
      buildWhen: (_, current) => !current.isLoading,
      builder: (context, state) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const TitleBar(title: "Configurações"),
              Column(
                children: [
                  SwitchListTile(
                    title: const Text("Tema noturno", style: AppTextStyles.verySmallSize),
                    value: state.isNightMode,
                    activeColor: AppColors.primary,
                    onChanged: (isChecked) => _onNightModeSwitch(context, isChecked),
                  ),
                  const SettingsDivider(),
                  SettingsItem("Som de alarme", "Alarme ${state.selectedAlarm + 1}", () => _onAlarmPressed(context, state.selectedAlarm)),
                  const SettingsDivider(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onStateChanged(BuildContext context, AppSettings state) {
    if (state.isLoading) {
      showDialog(context: context, builder: (_) => SimpleLoadingDialog());
    } else {
      Navigator.pop(context);
    }
  }

  void _onNightModeSwitch(BuildContext context, bool isNightMode) {
    context.read<AppSettingsCubit>().saveIsNightMode(isNightMode);
  }

  Future<void> _onAlarmPressed(BuildContext context, int selectedAlarmIdx) async {
    context.read<AppSettingsCubit>().playAlarmWithIndex(selectedAlarmIdx);

    var selectedValue = await showDialog<int?>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        int? _selectedIdx = selectedAlarmIdx;

        return AlertDialog(
          title: Text("Selecione o alarme"),
          contentPadding: EdgeInsets.zero,
          content: StatefulBuilder(
            builder: (context, alertSetState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: List<RadioListTile>.generate(4, (idx) {
                return RadioListTile<int>(
                  title: Text("Alarme ${idx + 1}"),
                  value: idx,
                  groupValue: _selectedIdx,
                  onChanged: (idx) => alertSetState(() {
                    _selectedIdx = idx;
                    context.read<AppSettingsCubit>().playAlarmWithIndex(idx);
                  }),
                );
              }),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text("CANCELAR"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, _selectedIdx),
              child: Text("CONFIRMAR"),
            ),
          ],
        );
      },
    );

    context.read<AppSettingsCubit>().stopPlayer();
    if (selectedValue != null) {
      context.read<AppSettingsCubit>().saveSelectedAlarm(selectedValue);
    }
  }
}

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0,
      indent: 16,
      endIndent: 16,
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String title;
  final String value;
  final Function onClick;

  const SettingsItem(this.title, this.value, this.onClick, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: AppTextStyles.verySmallSize),
      trailing: Text(value, style: AppTextStyles.verySmallSizeBold),
      onTap: () => onClick(),
    );
  }
}
