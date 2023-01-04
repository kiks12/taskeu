import 'package:flutter/material.dart';
import 'package:taskeu/screens/createScheduleScreen.dart';
import 'package:taskeu/utils/date.dart';
import 'package:taskeu/widgets/extended/exText.dart';

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
