import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:taskeu/screens/createScheduleScreen.dart';
import 'package:taskeu/utils/date.dart';
import 'package:taskeu/widgets/extended/exText.dart';

class AddTaskModal extends StatefulWidget {
  const AddTaskModal({
    super.key,
    // required this.initialDate,
    required this.selectedStartTime,
    required this.selectedEndTime,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.addTask,
    required this.handleTimeButtonClick,
  });

  // final DateTime initialDate =
  // Date(date: DateTime.now()).date.add(const Duration(days: 1));
  // List<Todo> todos = [];
  final TimeOfDay? selectedStartTime;
  final TimeOfDay? selectedEndTime;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final GlobalKey<FormState> formKey;
  final void Function() addTask;
  final Future<void> Function(String type) handleTimeButtonClick;
  // int currentID = 0;

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ExText(
                            text: (widget.selectedStartTime != null)
                                ? 'Start Time: ${widget.selectedStartTime!.format(context)}'
                                : 'Start Time:'),
                        TextButton(
                          onPressed: () async {
                            await widget.handleTimeButtonClick(START_TIME);
                            setState(() {});
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('Select Time'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ExText(
                            text: (widget.selectedEndTime != null)
                                ? 'End Time: ${widget.selectedEndTime!.format(context)}'
                                : 'End Time:'),
                        TextButton(
                          onPressed: () async {
                            await widget.handleTimeButtonClick(END_TIME);
                            setState(() {});
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('Select Time'),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Form(
                        key: widget.formKey,
                        child: Column(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const ExText(
                                  text: 'Title',
                                  size: 12,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please fill in this field.';
                                    }
                                    return null;
                                  },
                                  controller: widget.titleController,
                                  decoration:
                                      const InputDecoration(hintText: 'Title'),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const ExText(
                                    text: 'Decription',
                                    size: 12,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please fill in this field.';
                                      }
                                      return null;
                                    },
                                    maxLines: 10,
                                    controller: widget.descriptionController,
                                    decoration: const InputDecoration(
                                        hintText: 'Description'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black87),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: widget.addTask,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 10,
                          ),
                          child: Text('Add Task'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
