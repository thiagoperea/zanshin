import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanshin/data/datasource/database/dao/task_dao.dart';
import 'package:zanshin/data/model/task.dart';
import 'package:zanshin/utility/time_extensions.dart';

class TaskSettingsCubit extends Cubit<TaskSettingsState> {
  final TaskDao _dao = TaskDao(); // TODO: DI

  TaskSettingsCubit(Task task) : super(TaskSettingsState(state: TaskSettingsStates.idle, task: task));

  Future<void> updateWorkTime(String newWorkTime) async {
    _updateTask(() => state.task.workTimeSecs = int.parse(newWorkTime).minToSec());
  }

  Future<void> updateShortBreak(String newShortBreak) async {
    _updateTask(() => state.task.shortBreakSecs = int.parse(newShortBreak).minToSec());
  }

  Future<void> updateLongBreak(String newLongBreak) async {
    _updateTask(() => state.task.longBreakSecs = int.parse(newLongBreak).minToSec());
  }

  Future<void> updateSectionCount(String newSectionCount) async {
    _updateTask(() => state.task.sections = int.parse(newSectionCount));
  }

  Future<void> _updateTask(Function taskUpdate) async {
    try {
      emit(state.copyWith(state: TaskSettingsStates.loading));

      taskUpdate();
      await _dao.updateTask(state.task);

      emit(state.copyWith(state: TaskSettingsStates.success));
    } on Exception catch (error) {
      emit(
        state.copyWith(
          state: TaskSettingsStates.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}

class TaskSettingsState {
  TaskSettingsStates state;
  Task task;
  String? errorMessage;

  TaskSettingsState({required this.state, required this.task, this.errorMessage});

  bool wasUpdated() => state == TaskSettingsStates.success;

  TaskSettingsState copyWith({
    TaskSettingsStates? state,
    Task? task,
    String? errorMessage,
  }) {
    return TaskSettingsState(
      state: state ?? this.state,
      task: task ?? this.task,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

enum TaskSettingsStates { idle, loading, success, error }
