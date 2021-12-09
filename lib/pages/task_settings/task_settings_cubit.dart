import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanshin/data/datasource/database/dao/task_dao.dart';
import 'package:zanshin/data/model/task.dart';
import 'package:zanshin/utility/time_extensions.dart';

class TaskSettingsCubit extends Cubit<TaskSettingsState> {
  final TaskDao _dao = TaskDao(); // TODO: DI

  TaskSettingsCubit(Task task) : super(TaskSettingsState(state: TaskSettingsStates.idle, task: task));

  void setDescription(String? newValue) {
    if (newValue != null) {
      state.task.description = newValue;
      emit(state.copyWith());
    }
  }

  Future<void> updateTask(int workTime, int shortBreak, int longBreak, int sectionCount) async {
    try {
      emit(state.copyWith(state: TaskSettingsStates.loading));

      state.task.workTimeSecs = workTime.minToSec();
      state.task.shortBreakSecs = shortBreak.minToSec();
      state.task.longBreakSecs = longBreak.minToSec();
      state.task.sections = sectionCount;

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
