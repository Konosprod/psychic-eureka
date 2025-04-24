import 'package:flutter/material.dart';
import 'package:timotime/views/home/widgets/session_progress_title.dart';
import 'package:timotime/views/home/widgets/session_progress_widget.dart';
import 'package:timotime/views/home/widgets/task_description_widget.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SessionProgressTitle(),
            const SizedBox(height: 20),
            SessionProgressWidget(),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
              thickness: 1,
              height: 40,
            ),
            TaskDescriptionWidget(),
          ],
        ),
      ),
    );
  }
}
