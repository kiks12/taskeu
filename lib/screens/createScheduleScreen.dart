import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskeu/main.dart';
import 'package:taskeu/models/todo.dart';
import 'package:taskeu/utils/date.dart';
import 'package:taskeu/utils/taskUtils.dart';
import 'package:taskeu/widgets/create-schedule/createScheduleHeader.dart';
import 'package:taskeu/widgets/create-schedule/dateSelector.dart';
import 'package:taskeu/widgets/create-schedule/modals/addTaskModal.dart';
import 'package:taskeu/widgets/create-schedule/saveScheduleButton.dart';
import 'package:taskeu/widgets/extended/exText.dart';
import 'package:taskeu/widgets/tasks/task.dart';
import 'package:taskeu/widgets/tasks/tasks.dart';

import 'package:path/path.dart' as path;

const String START_TIME = 'START_TIME';
const String END_TIME = 'END_TIME';

class TaskCreationScreen extends StatefulWidget {
  const TaskCreationScreen({
    super.key,
  });

  @override
  State<TaskCreationScreen> createState() => _TaskCreationScreenState();
}

class _TaskCreationScreenState extends State<TaskCreationScreen> {
  DateTime initialDate =
      Date(date: DateTime.now()).date.add(const Duration(days: 1));
  DateTime? selectedDate;
  List<Todo> todos = [];
  TimeOfDay? selectedStartTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay? selectedEndTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay? selectedTime = const TimeOfDay(hour: 8, minute: 0);
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (todos.isNotEmpty) normalizeTodo();
  }

  void normalizeTodo() {
    todos = TaskUtils(todos: todos, isCreating: true).todos;
    setState(() {});
  }

  void setSelectedStartTimeToEndTime() {
    selectedStartTime = selectedEndTime;
    selectedEndTime = TimeOfDay(hour: selectedStartTime!.hour + 1, minute: 0);
  }

  void clearTextFormFields() {
    titleController.clear();
    descriptionController.clear();
  }

  int createStartTime() {
    if (selectedStartTime!.minute.toString().length == 1) {
      return int.parse(
          "${selectedStartTime!.hour}0${selectedStartTime!.minute}");
    }
    return int.parse("${selectedStartTime!.hour}${selectedStartTime!.minute}");
  }

  int createEndTime() {
    if (selectedEndTime!.hour == 0) {
      if (selectedEndTime!.minute.toString().length == 1) {
        return int.parse("${selectedEndTime!.hour}0${selectedEndTime!.minute}");
      }
      return int.parse("24${selectedEndTime!.minute}");
    }

    if (selectedEndTime!.minute.toString().length == 1) {
      return int.parse("${selectedEndTime!.hour}0${selectedEndTime!.minute}");
    }
    return int.parse("${selectedEndTime!.hour}${selectedEndTime!.minute}");
  }

  void addTask() {
    if (formKey.currentState!.validate()) {
      todos.add(
        Todo(
          id: 0,
          title: titleController.text,
          date: initialDate.millisecondsSinceEpoch,
          start: createStartTime(),
          end: createEndTime(),
          task: descriptionController.text,
          status: 'Scheduled',
        ),
      );
      setSelectedStartTimeToEndTime();
      clearTextFormFields();
      normalizeTodo();
      Navigator.pop(context);
    }
  }

  Future<void> saveSchedule() async {
    Todos(todos: todos).insertTodosToDB();
    Navigator.pop(context);
  }

  Future<void> selectStartTime() async {
    selectedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
    );
  }

  Future<void> handleTimeButtonClick(String type) async {
    await selectStartTime();
    if (selectedTime != null) {
      if (type == START_TIME) selectedStartTime = selectedTime;
      if (type == END_TIME) selectedEndTime = selectedTime;
    }
  }

  void showAddTaskModal() async {
    return await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      builder: ((context) {
        return AddTaskModal(
          selectedStartTime: selectedStartTime,
          selectedEndTime: selectedEndTime,
          formKey: formKey,
          titleController: titleController,
          descriptionController: descriptionController,
          addTask: addTask,
          handleTimeButtonClick: handleTimeButtonClick,
        );
      }),
    );
  }

  Future<void> showDateSelector() async {
    selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1800),
      lastDate: DateTime(2050),
    );
    setState(() {});
  }

  void handleDateChange() async {
    await showDateSelector();
    if (selectedDate != null) {
      initialDate = selectedDate!;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CreateScheduleHeader(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            DateSelector(
              initialDate: initialDate,
              handleDateChange: handleDateChange,
            ),
            Tasks(tasks: todos),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTaskModal,
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: SaveScheduleButton(
        saveSchedule: saveSchedule,
      ),
    );
  }
}
