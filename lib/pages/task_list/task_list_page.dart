import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanshin/common_widgets/one_button_dialog.dart';
import 'package:zanshin/common_widgets/simple_loading_dialog.dart';
import 'package:zanshin/common_widgets/single_input_dialog.dart';
import 'package:zanshin/common_widgets/title_bar.dart';
import 'package:zanshin/data/model/task.dart';
import 'package:zanshin/pages/task_list/task_list_cubit.dart';
import 'package:zanshin/pages/task_list/view/list_container.dart';

class TaskListPage extends StatefulWidget {
  final Function onTaskSelected;

  const TaskListPage({Key? key, required this.onTaskSelected}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final TaskListCubit _taskListCubit = TaskListCubit();

  @override
  void initState() {
    _taskListCubit.loadTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _taskListCubit,
      child: BlocListener<TaskListCubit, TaskListState>(
        listener: (context, state) => _onStateChanged(context, state.state),
        child: TaskListRoot(onTaskSelected: widget.onTaskSelected),
      ),
    );
  }

  void _onStateChanged(BuildContext context, TaskListStates state) {
    switch (state) {
      case TaskListStates.saveTaskLoading:
        _showSaveTaskLoading(context);
        break;
      case TaskListStates.saveTaskSuccess:
        Navigator.pop(context);
        context.read<TaskListCubit>().loadTasks();
        break;
      case TaskListStates.saveTaskError:
        Navigator.pop(context);
        _showSaveTaskError(context);
        break;
      case TaskListStates.deleteTaskLoading:
        _showDeleteTaskLoading(context);
        break;
      case TaskListStates.deleteTaskSuccess:
        Navigator.pop(context);
        context.read<TaskListCubit>().loadTasks();
        break;
      case TaskListStates.deleteTaskError:
        Navigator.pop(context);
        _showDeleteTaskError(context);
        break;
      default:
        break;
    }
  }

  void _showSaveTaskLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const SimpleLoadingDialog(loadingText: "Salvando tarefa..."),
    );
  }

  void _showSaveTaskError(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const OneButtonDialog(title: "Atenção", message: "Erro ao salvar tarefa!"),
    );
  }

  void _showDeleteTaskLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const SimpleLoadingDialog(loadingText: "Excluindo tarefa..."),
    );
  }

  void _showDeleteTaskError(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const OneButtonDialog(title: "Atenção", message: "Erro ao excluir tarefa!"),
    );
  }
}

class TaskListRoot extends StatelessWidget {
  final Function onTaskSelected;

  const TaskListRoot({Key? key, required this.onTaskSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TitleBar(title: "Lista de tarefas"),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListContainer(onTaskSelected: onTaskSelected),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, size: 28),
        onPressed: () => _onAddClick(context),
      ),
    );
  }

  void _onAddClick(BuildContext context) async {
    final Task? createdTask = await showDialog<Task?>(
      context: context,
      builder: (context) => SingleInputDialog(
        title: "Nova tarefa",
        inputLabel: "Descrição",
        confirmButtonLabel: "Adicionar",
        onConfirmClick: (String inputValue) {
          Task? task;

          if (inputValue.isNotEmpty) {
            task = Task.newTask(inputValue);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Não foi possível adicionar a tarefa :(")));
          }

          Navigator.pop(context, task);
        },
      ),
    );

    if (createdTask != null) {
      context.read<TaskListCubit>().saveTask(createdTask);
    }
  }
}
