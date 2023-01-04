import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import "package:intl/intl.dart";
import 'package:taskeu/widgets/extended/exText.dart';

class SevenDatesScroll extends StatefulWidget {
  const SevenDatesScroll({
    super.key,
    required this.dates,
    required this.now,
    required this.changeDate,
  });

  final List<DateTime> dates;
  final DateTime now;
  final void Function(DateTime date) changeDate;

  @override
  State<SevenDatesScroll> createState() => _SevenDatesScrollState();
}

class _SevenDatesScrollState extends State<SevenDatesScroll> {
  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    widget.dates.forEach((DateTime date) {
      Widget? dateWidget;
      if (date.compareTo(widget.now) == 0) {
        dateWidget = AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              ExText(
                text: DateFormat("dd").format(date),
                size: 16,
                weight: FontWeight.w600,
                color: Colors.white,
              ),
              ExText(
                text: DateFormat("EEEE").format(date).substring(0, 3),
                size: 10,
                weight: FontWeight.w500,
                color: Colors.white,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: CircleAvatar(
                  maxRadius: 2.5,
                  backgroundColor: Colors.white,
                ),
              )
            ],
          ),
        );
      } else {
        dateWidget = AnimatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          duration: const Duration(milliseconds: 1000),
          child: Column(
            children: [
              ExText(
                text: DateFormat("dd").format(date),
                size: 16,
                weight: FontWeight.w600,
                color: Colors.black38,
              ),
              ExText(
                text: DateFormat("EEEE").format(date).substring(0, 3),
                size: 10,
                weight: FontWeight.w500,
                color: Colors.black38,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: CircleAvatar(
                  maxRadius: 2.5,
                  backgroundColor: Colors.transparent,
                ),
              )
            ],
          ),
        );
      }
      list.add(
        Flexible(
          child: GestureDetector(
            onTap: () => widget.changeDate(date),
            child: dateWidget,
          ),
        ),
      );
    });

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: list,
      ),
    );
  }
}
