import 'package:taskeu/models/todo.dart';

class TaskUtils {
  final List<Todo> todos;
  int firstTime = 0;
  int lastTime = 0;

  TaskUtils({required this.todos}) {
    getFirstAndLastTime();
    fillInFreeTime();
  }

  void fillInFreeTime() {
    for (int i = 0; i < todos.length - 1; i++) {
      int endOfFirstTask = int.parse(todos[i].end.split(":")[0]);
      int startOfSecondTask = int.parse(todos[i + 1].start.split(":")[0]);
      if (endOfFirstTask != startOfSecondTask) {
        todos.insert(
          i + 1,
          Todo(
            id: 0,
            title: 'Free',
            date: 0,
            start: todos[i].end,
            end: todos[i + 1].start,
            task: 'Free',
            status: 'Free',
          ),
        );
      }
    }

    for (int i = lastTime; i < 24; i++) {
      todos.add(
        Todo(
          id: 0,
          title: 'Free',
          date: 0,
          start: '$i:00',
          end: '${i + 1}:00',
          task: 'Free',
          status: 'Free',
        ),
      );
    }
  }

  void getFirstAndLastTime() {
    Todo first = todos.first;
    Todo last = todos.last;
    firstTime = int.parse(first.start.split(":")[0]);
    lastTime = int.parse(last.end.split(":")[0]);
  }
}
