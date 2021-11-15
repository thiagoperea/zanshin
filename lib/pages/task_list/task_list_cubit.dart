import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanshin/data/datasource/database/dao/task_dao.dart';
import 'package:zanshin/data/model/task.dart';

class TaskListCubit extends Cubit<TaskListState> {
  Task? _lastSavedTask;

  TaskListCubit() : super(TaskListState(state: TaskListStates.idle));

  final TaskDao _dao = TaskDao();

  Future<void> loadTasks() async {
    try {
      emit(state.copyWith(state: TaskListStates.taskListLoading));

      final List<Task> allTasks = await _dao.getAllTasks();
      emit(
        state.copyWith(
          state: TaskListStates.taskListSuccess,
          taskList: allTasks,
        ),
      );
    } on Exception catch (error) {
      emit(
        state.copyWith(
          state: TaskListStates.taskListError,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> saveTask(Task task) async {
    try {
      emit(state.copyWith(state: TaskListStates.saveTaskLoading));

      await _dao.saveTask(task);
      _lastSavedTask = task;
      emit(state.copyWith(state: TaskListStates.saveTaskSuccess));
    } on Exception catch (error) {
      emit(
        state.copyWith(
          state: TaskListStates.saveTaskError,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> deleteTask(Task task) async {
    try {
      emit(state.copyWith(state: TaskListStates.deleteTaskLoading));

      await _dao.deleteTask(task);

      if (task == _lastSavedTask) {
        _lastSavedTask = null;
      }

      emit(state.copyWith(state: TaskListStates.deleteTaskSuccess));
    } on Exception catch (error) {
      emit(
        state.copyWith(
          state: TaskListStates.deleteTaskError,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Task? getLastSavedTask() => _lastSavedTask;
}

class TaskListState {
  final TaskListStates state;
  final List<Task>? taskList;
  final String? errorMessage;

  TaskListState({required this.state, this.taskList, this.errorMessage});

  TaskListState copyWith({
    TaskListStates? state,
    List<Task>? taskList,
    String? errorMessage,
  }) {
    return TaskListState(
      state: state ?? this.state,
      taskList: taskList ?? this.taskList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'TaskListState{state: $state, taskList: $taskList, errorMessage: $errorMessage}';
  }
}

enum TaskListStates {
  idle,
  taskListLoading,
  taskListSuccess,
  taskListError,
  saveTaskLoading,
  saveTaskSuccess,
  saveTaskError,
  deleteTaskLoading,
  deleteTaskSuccess,
  deleteTaskError,
}
