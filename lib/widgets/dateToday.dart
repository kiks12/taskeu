import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:taskeu/widgets/extended/exText.dart';

class DateToday extends StatelessWidget {
  const DateToday({super.key, required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExText(
                text: DateFormat("MMMM dd").format(now),
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
            onTap: () {},
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
