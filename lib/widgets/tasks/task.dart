import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taskeu/models/todo.dart';
import 'package:taskeu/screens/homeScreen.dart';
import 'package:taskeu/widgets/create-schedule/modals/addTaskModal.dart';
import 'package:taskeu/widgets/extended/exText.dart';

List<Color> colors = [
  const Color.fromARGB(255, 153, 177, 204),
  const Color.fromARGB(255, 187, 207, 161),
  const Color.fromARGB(255, 213, 167, 167),
  const Color.fromARGB(255, 221, 193, 213),
  const Color.fromARGB(255, 160, 190, 171),
];

class Task extends StatefulWidget {
  const Task(
      {super.key,
      required this.task,
      required this.changeTaskStatus,
      required this.deleteTask});

  final Todo task;
  final void Function(String newStatus, int id) changeTaskStatus;
  final void Function(int id) deleteTask;

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

  // void showAddTaskModal() async {
  //   return await showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
  //     builder: ((context) {
  //       return AddTaskModal(
  //         selectedStartTime: selectedStartTime,
  //         selectedEndTime: selectedEndTime,
  //         formKey: formKey,
  //         titleController: titleController,
  //         descriptionController: descriptionController,
  //         addTask: addTask,
  //         handleTimeButtonClick: handleTimeButtonClick,
  //       );
  //     }),
  //   );
  // }

  Color getColor() {
    if (widget.task.status == 'Cancelled') return Colors.red;
    if (widget.task.status == 'Completed') return Colors.yellow;
    return colors[Random().nextInt(colors.length)];
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
              child: Slidable(
                startActionPane: ActionPane(
                  motion: const StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: ((context) {
                        widget.changeTaskStatus(CANCELLED_TASK, widget.task.id);
                      }),
                      icon: Icons.cancel,
                      borderRadius: BorderRadius.circular(15),
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    SlidableAction(
                      onPressed: ((context) {
                        widget.deleteTask(widget.task.id);
                      }),
                      icon: Icons.delete,
                      borderRadius: BorderRadius.circular(15),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: ((context) {}),
                      backgroundColor: Colors.teal,
                      borderRadius: BorderRadius.circular(15),
                      icon: Icons.edit,
                    ),
                    SlidableAction(
                      onPressed: ((context) {
                        widget.changeTaskStatus(COMPLETED_TASK, widget.task.id);
                      }),
                      backgroundColor: Colors.yellow,
                      borderRadius: BorderRadius.circular(15),
                      icon: Icons.check,
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: getColor(),
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
            ),
          ],
        ),
      ),
    );
  }
}
