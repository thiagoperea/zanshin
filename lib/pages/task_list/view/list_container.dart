import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanshin/common_widgets/simple_loading.dart';
import 'package:zanshin/common_widgets/simple_message.dart';
import 'package:zanshin/data/model/task.dart';
import 'package:zanshin/pages/task_list/task_list_cubit.dart';
import 'package:zanshin/pages/task_list/view/list_item.dart';
import 'package:zanshin/pages/task_settings/task_settings_page.dart';

class ListContainer extends StatelessWidget {
  final Function onTaskSelected;

  const ListContainer({Key? key, required this.onTaskSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskListCubit, TaskListState>(
      buildWhen: (_, currentState) => _shouldReloadPage(currentState.state),
      builder: (context, state) {
        if (state.state == TaskListStates.taskListLoading) {
          return const SimpleLoading();
        } else if (state.state == TaskListStates.taskListSuccess) {
          return _onLoadSuccess(state.taskList!);
        } else {
          return SimpleMessage("Erro: ${state.errorMessage}", icon: Icons.warning);
        }
      },
    );
  }

  Widget _onLoadSuccess(List<Task> dataset) {
    if (dataset.isEmpty) {
      return const SimpleMessage("Lista de tarefas vazia :(");
    }

    return ListView.builder(
      itemBuilder: (context, idx) {
        return ListItem(
          task: dataset[idx],
          onItemClick: (task) => onTaskSelected(task),
          onEditClick: (task) => _onEditClick(context, task),
          onDeleteClick: (task) => _onDeleteClick(context, task),
        );
      },
      itemCount: dataset.length,
    );
  }

  bool _shouldReloadPage(TaskListStates taskState) =>
      taskState == TaskListStates.taskListLoading || taskState == TaskListStates.taskListSuccess || taskState == TaskListStates.taskListError;

  Future<void> _onEditClick(BuildContext context, Task task) async {
    await Navigator.of(context).pushNamed(TaskSettingsPage.route, arguments: task);

    context.read<TaskListCubit>().loadTasks();
  }

  _onDeleteClick(BuildContext context, task) => context.read<TaskListCubit>().deleteTask(task);
}
