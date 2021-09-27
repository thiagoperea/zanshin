import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:zanshin/data/datasource/preferences/app_preferences.dart';

class AppSettingsCubit extends Cubit<AppSettings> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AppSettingsCubit() : super(AppSettings(isLoading: false));

  Future<void> loadSettings() async {
    emit(state.copyWith(isLoading: true));

    final bool nightMode = await AppPreferences.isNightMode();
    final int selectedAlarm = await AppPreferences.getSelectedAlarm();

    emit(state.copyWith(isLoading: false, isNightMode: nightMode, selectedAlarm: selectedAlarm));
  }

  Future<void> saveIsNightMode(bool isNightMode) async {
    emit(state.copyWith(isLoading: true));

    await AppPreferences.saveNightMode(isNightMode);
    loadSettings();
  }

  Future<void> saveSelectedAlarm(int selectedAlarm) async {
    emit(state.copyWith(isLoading: true));

    await AppPreferences.saveSelectedAlarm(selectedAlarm);
    loadSettings();
  }

  Future<void> playAlarmWithIndex(int? alarmIdx) async {
    stopPlayer();

    await _audioPlayer.setAsset("assets/alarm/alarm_$alarmIdx.mp3");

    _audioPlayer.play();
  }

  void stopPlayer() => _audioPlayer.stop();
}

class AppSettings {
  final bool isLoading;
  final bool isNightMode;
  final int selectedAlarm;

  AppSettings({required this.isLoading, this.isNightMode = false, this.selectedAlarm = 0});

  AppSettings copyWith({
    bool? isLoading,
    bool? isNightMode,
    int? selectedAlarm,
  }) {
    return AppSettings(
      isLoading: isLoading ?? this.isLoading,
      isNightMode: isNightMode ?? this.isNightMode,
      selectedAlarm: selectedAlarm ?? this.selectedAlarm,
    );
  }

  @override
  String toString() {
    return 'AppSettings{isLoading: $isLoading, isNightMode: $isNightMode, selectedAlarm: $selectedAlarm}';
  }
}
