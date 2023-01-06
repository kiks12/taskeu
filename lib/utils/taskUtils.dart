import 'package:taskeu/models/todo.dart';

class TaskUtils {
  final List<Todo> todos;
  final bool isCreating;
  int firstTime = 0;
  int lastTime = 0;

  TaskUtils({required this.todos, this.isCreating = false}) {
    getFirstAndLastTime();
    fillInFreeTime();
  }

  int processEndOfFirstTask(Todo todo) {
    if (todo.end.toString().length == 3 || todo.end.toString().length == 2) {
      return int.parse(todo.end.toString()[0]);
    }
    return int.parse(todo.end.toString().substring(0, 2));
  }

  int processStartOfSecondTask(Todo todo) {
    if (todo.start.toString().length == 3 ||
        todo.start.toString().length == 2) {
      return int.parse(todo.start.toString()[0]);
    }
    return int.parse(todo.start.toString().substring(0, 2));
  }

  void fillInFreeTime() {
    for (int i = 0; i < todos.length - 1; i++) {
      int endOfFirstTask = processEndOfFirstTask(todos[i]);
      int startOfSecondTask = processStartOfSecondTask(todos[i + 1]);
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

    if (!isCreating) {
      for (int i = lastTime; i < 24; i++) {
        todos.add(
          Todo(
            id: 0,
            title: 'Free',
            date: 0,
            start: int.parse('${i}00'),
            end: int.parse('${i + 1}00'),
            task: 'Free',
            status: 'Free',
          ),
        );
      }
    }
  }

  int processFirstTime(Todo todo) {
    if (todo.start.toString().length == 3 ||
        todo.start.toString().length == 2) {
      return int.parse(todo.start.toString()[0]);
    }
    return int.parse(todo.start.toString().substring(0, 2));
  }

  int processLastTime(Todo todo) {
    if (todo.end.toString().length == 3 || todo.end.toString().length == 2) {
      return int.parse(todo.end.toString()[0]);
    }
    return int.parse(todo.end.toString().substring(0, 2));
  }

  void getFirstAndLastTime() {
    Todo first = todos.first;
    Todo last = todos.last;
    firstTime = processFirstTime(first);
    lastTime = processLastTime(last);
  }
}
