import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zanshin/data/model/task.dart';
import 'package:zanshin/pages/app_settings/app_settings_page.dart';
import 'package:zanshin/pages/pomodoro/pomodoro_page.dart';
import 'package:zanshin/pages/task_list/task_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIdx = 0;
  Task? _selectedTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedScreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.square_list), label: "Lista de tarefas"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.clock_fill), label: "Tarefa atual"),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: "Configurações"),
        ],
        showUnselectedLabels: false,
        showSelectedLabels: false,
        iconSize: 32,
        currentIndex: _bottomNavIdx,
        onTap: (idx) => _onMenuSelected(idx),
      ),
    );
  }

  void _onMenuSelected(int index) {
    setState(() {
      _bottomNavIdx = index;
    });
  }

  Widget _getSelectedScreen() {
    switch (_bottomNavIdx) {
      case 0:
        return TaskListPage(onTaskSelected: (task) => _onTaskSelected(task));
      case 1:
        return PomodoroPage(task: _selectedTask);
      case 2:
        return const AppSettingsPage();
      default:
        throw Exception("Unhandled case!");
    }
  }

  void _onTaskSelected(Task task) {
    setState(() {
      _selectedTask = task;
      _bottomNavIdx = 1;
    });
  }
}
