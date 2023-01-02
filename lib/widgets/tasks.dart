import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:taskeu/models/todo.dart';
import 'package:taskeu/widgets/task.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key, required this.tasks});

  final List<Todo> tasks;

  List<Widget> get taskContainer => [];

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final List<Widget> taskContainer = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        itemCount: widget.tasks.length,
        itemBuilder: ((context, index) {
          return Task(task: widget.tasks[index]);
        }),
      ),
    );
  }
}
