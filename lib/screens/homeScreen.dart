import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskeu/screens/createTaskScreen.dart';
import 'package:taskeu/utils/date.dart';
import 'package:taskeu/utils/taskUtils.dart';
import 'package:taskeu/widgets/extended/exText.dart';
import 'package:path/path.dart' as path;
import 'package:taskeu/widgets/taskSchedule.dart';

import '../models/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  final searchBarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    todos = TaskUtils(todos: todos).todos;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const Header(),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            if (index == 0) return const WelcomingComp();

            if (index == 1) {
              return SearchBar(
                searchTodo: () {},
                controller: searchBarController,
              );
            }

            return TaskSchedule(todos: todos);
          },
        ),
      ),
      bottomNavigationBar: const CreateScheduleButton(),
    );
  }
}

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const ExText(
              text: 'Taskeu',
              size: 20,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.settings,
                size: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class WelcomingComp extends StatefulWidget {
  const WelcomingComp({super.key});

  @override
  State<WelcomingComp> createState() => WelcomingCompState();
}

class WelcomingCompState extends State<WelcomingComp> {
  String? username;
  String? avaterLetter;
  int? scheduledCount;
  late Database db;

  Future<void> openDB() async {
    db = await openDatabase(
      path.join(await getDatabasesPath(), 'official_taskeu_2.db'),
    );
  }

  Future<void> getUsername() async {
    username = (await db.rawQuery('SELECT * FROM user WHERE id=0'))[0]
        ['username'] as String;
  }

  Future<void> getScheduledTasks() async {
    scheduledCount = Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM todo WHERE status="Scheduled"'));
  }

  Future<void> getAvatarLetter() async {
    avaterLetter =
        ((await db.rawQuery('SELECT firstName FROM user WHERE id=0'))[0]
            ['firstName'] as String)[0];
    setState(() {});
  }

  Future<void> initStateCallback() async {
    await openDB();
    await getUsername();
    await getScheduledTasks();
    await getAvatarLetter();
  }

  @override
  void initState() {
    super.initState();
    initStateCallback();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExText(
                text: (username != null) ? 'Hi $username' : '',
                size: 24,
                weight: FontWeight.w600,
              ),
              ExText(
                text: (scheduledCount != null)
                    ? '$scheduledCount Scheduled Tasks'
                    : '',
                size: 12,
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: Colors.black87,
            child: ExText(
              color: Colors.white,
              text: (avaterLetter != null) ? avaterLetter!.toUpperCase() : "",
            ),
          )
        ],
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({
    super.key,
    required this.searchTodo,
    required this.controller,
  });

  final void searchTodo;
  final TextEditingController controller;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          children: [
            Flexible(
              child: TextFormField(
                controller: widget.controller,
                decoration: const InputDecoration(
                  hintText: 'Search Tasks',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: GestureDetector(
                onTap: () {},
                child: const CircleAvatar(
                  maxRadius: 26,
                  backgroundColor: Colors.black87,
                  child: Icon(
                    Icons.search,
                    size: 17,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CreateScheduleButton extends StatefulWidget
    implements PreferredSizeWidget {
  const CreateScheduleButton({super.key});

  @override
  State<CreateScheduleButton> createState() => _CreateScheduleButtonState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _CreateScheduleButtonState extends State<CreateScheduleButton> {
  DateTime date = Date(date: DateTime.now()).date.add(const Duration(days: 1));

  void changeDate(DateTime newDate) {
    date = Date(date: newDate).date;
    setState(() {});
  }

  void showTaskCreationScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TaskCreationScreen(),
      ),
    );
  }

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
            onPressed: () => showTaskCreationScreen(context),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: ExText(
                text: 'Create Schedule',
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(10);
}
