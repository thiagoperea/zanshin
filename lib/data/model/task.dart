import 'package:hive/hive.dart';
import 'package:zanshin/utility/time_extensions.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String description;

  @HiveField(1)
  int workTimeSecs;

  @HiveField(2)
  int shortBreakSecs;

  @HiveField(3)
  int longBreakSecs;

  @HiveField(4)
  int sections;

  Task(this.description, this.workTimeSecs, this.shortBreakSecs, this.longBreakSecs, this.sections);

  factory Task.newTask(String description) => Task(description, 25.minToSec(), 5.minToSec(), 15.minToSec(), 4);

  @override
  String toString() {
    return 'Task{'
        'description: $description, '
        'workTimeSecs: $workTimeSecs, '
        'shortBreakSecs: $shortBreakSecs, '
        'longBreakSecs: $longBreakSecs, '
        'sections: $sections'
        '}';
  }
}
