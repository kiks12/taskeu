import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:taskeu/models/todo.dart';
import 'package:taskeu/widgets/extended/exText.dart';

List<Color> colors = [
  const Color.fromARGB(255, 153, 177, 204),
  const Color.fromARGB(255, 187, 207, 161),
  const Color.fromARGB(255, 213, 167, 167),
  const Color.fromARGB(255, 221, 193, 213),
  const Color.fromARGB(255, 160, 190, 171),
];

class Task extends StatefulWidget {
  const Task({super.key, required this.task});

  final Todo task;

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  int firstTime = 0;
  int lastTime = 0;

  List<Widget> allTime = [];

  void initializeAllTime() {
    for (int i = 0; i <= lastTime - firstTime; i++) {
      String time = '${firstTime + i}:00';
      allTime.add(
        ExText(
          text: time,
          size: 12,
          color: Colors.black45,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    firstTime = int.parse(widget.task.start.split(':')[0]);
    lastTime = int.parse(widget.task.end.split(':')[0]);
    initializeAllTime();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.task.status == 'Free') {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: SizedBox(
          height: (lastTime - firstTime) *
              MediaQuery.of(context).size.height *
              0.09,
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: allTime,
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(14, 0, 0, 0),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          size: 18,
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        height:
            (lastTime - firstTime) * MediaQuery.of(context).size.height * 0.09,
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: allTime,
              ),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: colors[Random().nextInt(colors.length)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ExText(
                      text: widget.task.title,
                      size: 12,
                      weight: FontWeight.w500,
                    ),
                    ExText(
                      text: widget.task.task,
                      size: 14,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
