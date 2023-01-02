import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:taskeu/models/todo.dart';
import 'package:taskeu/utils/date.dart';
import 'package:taskeu/utils/taskUtils.dart';
import 'package:taskeu/widgets/extended/exText.dart';
import 'package:taskeu/widgets/task.dart';
import 'package:taskeu/widgets/tasks.dart';

class TaskCreationScreen extends StatefulWidget {
  const TaskCreationScreen({
    super.key,
  });

  @override
  State<TaskCreationScreen> createState() => _TaskCreationScreenState();
}

class _TaskCreationScreenState extends State<TaskCreationScreen> {
  List<Todo> todos = [
    const Todo(
      id: 0,
      title: 'Title 1',
      date: 1672675200000,
      start: '7:00',
      end: '8:00',
      task: 'Create Blah',
      status: 'Scheduled',
    ),
    const Todo(
      id: 1,
      title: 'Title 2',
      date: 1672675200000,
      start: '10:00',
      end: '12:00',
      task: 'Create Blah',
      status: 'Scheduled',
    ),
    const Todo(
      id: 1,
      title: 'Lunch',
      date: 1672675200000,
      start: '12:00',
      end: '13:00',
      task: 'Eat Lunch',
      status: 'Scheduled',
    ),
  ];

  @override
  void initState() {
    super.initState();
    todos = TaskUtils(todos: todos).todos;
    setState(() {});
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
      bottomNavigationBar: const SaveScheduleButton(),
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
  const SaveScheduleButton({super.key});

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
            onPressed: () {},
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
