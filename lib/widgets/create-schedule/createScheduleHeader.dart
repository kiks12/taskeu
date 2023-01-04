import 'package:flutter/material.dart';
import 'package:taskeu/widgets/extended/exText.dart';

class CreateScheduleHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const CreateScheduleHeader({super.key});

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
