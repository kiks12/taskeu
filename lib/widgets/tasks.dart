import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key, required this.day});

  final int day;

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        widget.day.toString(),
      ),
    );
  }
}
