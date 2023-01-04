import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskeu/main.dart';
import 'package:taskeu/models/todo.dart';
import 'package:taskeu/utils/date.dart';
import 'package:taskeu/utils/taskUtils.dart';
import 'package:taskeu/widgets/extended/exText.dart';
import 'package:taskeu/widgets/task.dart';
import 'package:taskeu/widgets/tasks.dart';

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
  List<Todo> todos = [];
  TimeOfDay? selectedStartTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay? selectedEndTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay? selectedTime = const TimeOfDay(hour: 8, minute: 0);
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int currentID = 0;

  @override
  void initState() {
    super.initState();
    if (todos.isNotEmpty) normalizeTodo();
    getID();
  }

  void normalizeTodo() {
    todos = TaskUtils(todos: todos, isCreating: true).todos;
    setState(() {});
  }

  Future<void> getID() async {
    final Database db = await openDatabase(
      path.join(
        await getDatabasesPath(),
        DB_NAME,
      ),
    );

    currentID =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM todo'))
            as int;
    setState(() {});
  }

  void addTask() {
    if (formKey.currentState!.validate()) {
      todos.add(
        Todo(
          id: currentID,
          title: titleController.text,
          date: initialDate.millisecondsSinceEpoch,
          start: selectedStartTime!.format(context),
          end: selectedEndTime!.format(context),
          task: descriptionController.text,
          status: 'Scheduled',
        ),
      );
      currentID++;
      normalizeTodo();
      Navigator.pop(context);
    }
  }

  Future<void> saveSchedule() async {
    for (var todo in todos) {
      if (todo.status == 'Free') continue;
      todo.insertUserToDB();
    }
    Navigator.pop(context);
  }

  Future<void> selectStartTime() async {
    selectedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
    );
  }

  Future<void> handleStartTimeButtonClick(String type) async {
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
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
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
                                text: (selectedStartTime != null)
                                    ? 'Start Time: ${selectedStartTime!.format(context)}'
                                    : 'Start Time:'),
                            TextButton(
                              onPressed: () async {
                                await handleStartTimeButtonClick(START_TIME);
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
                                text: (selectedEndTime != null)
                                    ? 'End Time: ${selectedEndTime!.format(context)}'
                                    : 'End Time:'),
                            TextButton(
                              onPressed: () async {
                                await handleStartTimeButtonClick(END_TIME);
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
                            key: formKey,
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
                                      controller: titleController,
                                      decoration: const InputDecoration(
                                          hintText: 'Title'),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        controller: descriptionController,
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
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black87),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            ),
                            onPressed: addTask,
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
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const DateSelector(),
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

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
              ),
            ),
            const ExText(
              text: 'Create Schedule',
              weight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(100);
}

class DateSelector extends StatefulWidget {
  const DateSelector({
    super.key,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTime initialDate =
      Date(date: DateTime.now()).date.add(const Duration(days: 1));
  DateTime? selectedDate;

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ExText(
            text: DateFormat("MMMM DD").format(initialDate),
            size: 20,
            weight: FontWeight.w600,
          ),
          GestureDetector(
            onTap: handleDateChange,
            child: const CircleAvatar(
              backgroundColor: Colors.black87,
              child: Icon(
                Icons.calendar_month,
                size: 19,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SaveScheduleButton extends StatefulWidget implements PreferredSizeWidget {
  const SaveScheduleButton({
    super.key,
    required this.saveSchedule,
  });

  final Future<void> Function() saveSchedule;

  @override
  State<SaveScheduleButton> createState() => _SaveScheduleButtonState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _SaveScheduleButtonState extends State<SaveScheduleButton> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black87),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: widget.saveSchedule,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: ExText(
                text: 'Save Schedule',
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
