import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ExText extends StatefulWidget {
  const ExText({
    super.key,
    required this.text,
    this.size = 15,
    this.weight = FontWeight.w500,
    this.color = Colors.black,
  });

  final String text;
  final FontWeight weight;
  final Color color;
  final double size;

  @override
  State<ExText> createState() => _ExTextState();
}

class _ExTextState extends State<ExText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: widget.weight,
        color: widget.color,
        fontSize: widget.size,
      ),
    );
  }
}
