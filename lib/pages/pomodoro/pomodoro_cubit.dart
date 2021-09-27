import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:zanshin/data/model/task.dart';
import 'package:zanshin/pages/task_settings/task_settings_page.dart';
import 'package:zanshin/utility/vibration_service.dart';

class PomodoroCubit extends Cubit<PomodoroState> {
  PomodoroStates _lastState = PomodoroStates.stop;
  int _selectedAlarmIdx = 0;
  Timer _timer = Timer(Duration.zero, () {});
  final AudioPlayer _audioPlayer = AudioPlayer();

  PomodoroCubit(PomodoroState state) : super(state);

  factory PomodoroCubit.empty() => PomodoroCubit(PomodoroState.empty());

  factory PomodoroCubit.fromTask(Task data, int selectedAlarm) => PomodoroCubit(PomodoroState.fromTask(data)).._selectedAlarmIdx = selectedAlarm;

  @override
  Future<void> close() {
    _timer.cancel();
    _audioPlayer.dispose();
    return super.close();
  }

  /// Resume or pause the current task
  void onPlayPauseClick() {
    if (state.isPlaying()) {
      _pauseTask();
    } else {
      if (_lastState == PomodoroStates.work || _lastState == PomodoroStates.stop) {
        _resumeWork(false);
      } else if (_lastState == PomodoroStates.shortBreak || _lastState == PomodoroStates.longBreak) {
        _resumeBreak(false);
      }
    }
  }

  /// Stop current task and reset the UI
  void stopTask() {
    if (state.taskData != null) {
      emit(
        state.copyWith(
          state: PomodoroStates.stop,
          timeRemaining: state.taskData!.workTimeSecs,
          currentSection: 1,
          progressRemaining: 1.0,
        ),
      );
    }
    _timer.cancel();
  }

  /// Called when a task is updated via [TaskSettingsPage].
  void updateTask(Task task) {
    emit(state.copyWith(taskData: task));
    stopTask();
  }

  /// Called when pause button is clicked, the last state is stored, the audio player and the timer are paused.
  void _pauseTask() {
    _lastState = state.state;
    emit(state.copyWith(state: PomodoroStates.pause));
    _audioPlayer.stop();
    _timer.cancel();
  }

  void _resumeWork(bool newWork) {
    emit(
      state.copyWith(
        state: PomodoroStates.work,
        timeRemaining: newWork ? state.taskData!.workTimeSecs : null,
        progressRemaining: newWork ? 1.0 : null,
      ),
    );

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state.timeRemaining <= 0) {
        timer.cancel();
        _doAfterWork();
      } else {
        emit(
          state.copyWith(
            timeRemaining: state.timeRemaining - 1,
            progressRemaining: (state.timeRemaining - 1) / state.taskData!.workTimeSecs,
          ),
        );
      }
    });
  }

  /// Dispatch the alarm, notification and vibration then resumes the break
  void _doAfterWork() {
    VibrationService.simpleVibration();
    _playAlarm();

    _resumeBreak(true);
  }

  /// Emit the initial
  void _resumeBreak(bool newBreak) {
    if (!state.isLastSection()) {
      emit(
        state.copyWith(
          state: PomodoroStates.shortBreak,
          timeRemaining: newBreak ? state.taskData!.shortBreakSecs : null,
          progressRemaining: newBreak ? 1.0 : null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          state: PomodoroStates.longBreak,
          timeRemaining: newBreak ? state.taskData!.longBreakSecs : null,
          progressRemaining: newBreak ? 1.0 : null,
        ),
      );
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state.timeRemaining <= 0) {
        timer.cancel();
        _doAfterBreak();
        return;
      }

      if (!state.isLastSection()) {
        emit(
          state.copyWith(
            timeRemaining: state.timeRemaining - 1,
            progressRemaining: (state.timeRemaining - 1) / state.taskData!.shortBreakSecs,
          ),
        );
      } else {
        emit(
          state.copyWith(
            timeRemaining: state.timeRemaining - 1,
            progressRemaining: (state.timeRemaining - 1) / state.taskData!.longBreakSecs,
          ),
        );
      }
    });
  }

  void _doAfterBreak() {
    VibrationService.simpleVibration();
    _playAlarm();

    if (state.isLastSection()) {
      stopTask();
    } else {
      emit(
        state.copyWith(
          timeRemaining: state.taskData!.workTimeSecs,
          progressRemaining: 1.0,
          currentSection: state.currentSection + 1,
        ),
      );
      _resumeWork(true);
    }
  }

  Future<void> _playAlarm() async {
    await _audioPlayer.setAsset("assets/alarm/alarm_$_selectedAlarmIdx.mp3");

    _audioPlayer.play();
  }
}

class PomodoroState {
  PomodoroStates state;
  Task? taskData;
  int currentSection;
  int timeRemaining;
  double progressRemaining;

  PomodoroState({required this.state, required this.taskData, required this.currentSection, required this.timeRemaining, required this.progressRemaining});

  factory PomodoroState.empty() => PomodoroState(
        state: PomodoroStates.stop,
        taskData: null,
        currentSection: 0,
        timeRemaining: 0,
        progressRemaining: 1,
      );

  factory PomodoroState.fromTask(Task task) => PomodoroState(
        state: PomodoroStates.stop,
        taskData: task,
        currentSection: 1,
        timeRemaining: task.workTimeSecs,
        progressRemaining: 1.0,
      );

  bool hasTask() => taskData != null;

  bool isPlaying() => state != PomodoroStates.pause && state != PomodoroStates.stop;

  bool isLastSection() => currentSection == taskData!.sections;

  @override
  String toString() {
    return 'playbackState: $state, currentSection: $currentSection, timeRemaining: $timeRemaining, progressRemaining: $progressRemaining';
  }

  PomodoroState copyWith({
    PomodoroStates? state,
    Task? taskData,
    int? currentSection,
    int? timeRemaining,
    double? progressRemaining,
  }) {
    return PomodoroState(
      state: state ?? this.state,
      taskData: taskData ?? this.taskData,
      currentSection: currentSection ?? this.currentSection,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      progressRemaining: progressRemaining ?? this.progressRemaining,
    );
  }
}

enum PomodoroStates { work, pause, stop, shortBreak, longBreak }
