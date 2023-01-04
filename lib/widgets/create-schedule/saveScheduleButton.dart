import 'package:flutter/material.dart';
import 'package:taskeu/widgets/extended/exText.dart';

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
