import 'package:flutter/material.dart';
import 'package:taskeu/utils/date.dart';
import 'package:taskeu/widgets/extended/exText.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({
    super.key,
    required this.initialDate,
    required this.handleDateChange,
  });

  final DateTime initialDate;
  final void Function() handleDateChange;

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  // DateTime initialDate =
  // Date(date: DateTime.now()).date.add(const Duration(days: 1));
  // DateTime? selectedDate;

  // Future<void> showDateSelector() async {
  //   selectedDate = await showDatePicker(
  //     context: context,
  //     initialDate: initialDate,
  //     firstDate: DateTime(1800),
  //     lastDate: DateTime(2050),
  //   );
  //   setState(() {});
  // }

  // void handleDateChange() async {
  //   await showDateSelector();
  //   if (selectedDate != null) {
  //     initialDate = selectedDate!;
  //     setState(() {});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ExText(
            text: DateFormat("MMMM DD").format(widget.initialDate),
            size: 20,
            weight: FontWeight.w600,
          ),
          GestureDetector(
            onTap: widget.handleDateChange,
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
