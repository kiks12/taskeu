import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:taskeu/widgets/extended/exText.dart';

class DateToday extends StatefulWidget {
  const DateToday({
    super.key,
    required this.now,
    required this.chooseDate,
  });

  final void Function() chooseDate;
  final DateTime now;

  @override
  State<DateToday> createState() => _DateTodayState();
}

class _DateTodayState extends State<DateToday> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExText(
                text: DateFormat("MMMM dd").format(widget.now),
                size: 18,
                weight: FontWeight.w600,
              ),
              const ExText(
                text: '0 tasks Today',
                size: 12,
              ),
            ],
          ),
          GestureDetector(
            onTap: widget.chooseDate,
            child: const CircleAvatar(
              maxRadius: 23,
              backgroundColor: Colors.black87,
              child: Icon(
                Icons.calendar_month,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
