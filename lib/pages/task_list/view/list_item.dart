import 'package:flutter/material.dart';
import 'package:zanshin/data/model/task.dart';
import 'package:zanshin/styles/app_text_styles.dart';
import 'package:zanshin/utility/time_extensions.dart';

class ListItem extends StatelessWidget {
  final Task task;
  final Function onItemClick;
  final Function onEditClick;
  final Function onDeleteClick;

  const ListItem({
    Key? key,
    required this.task,
    required this.onItemClick,
    required this.onEditClick,
    required this.onDeleteClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String workTime = task.workTimeSecs.secToMin().toStringAsFixed(1);
    String shortBreakTime = task.shortBreakSecs.secToMin().toStringAsFixed(1);
    String longBreakTime = task.longBreakSecs.secToMin().toStringAsFixed(1);

    return Card(
      child: ListTile(
        onTap: () => onItemClick(task),
        title: Text(task.description, style: AppTextStyles.smallSizeBold),
        subtitle: Text(
          "Trabalho: ${task.sections}x ${workTime}min\n"
          "Descanso: ${shortBreakTime}min - ${longBreakTime}min",
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: () => onEditClick.call(task), icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.onSurface)),
            IconButton(onPressed: () => onDeleteClick.call(task), icon: Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.onSurface)),
          ],
        ),
      ),
    );
  }
}
