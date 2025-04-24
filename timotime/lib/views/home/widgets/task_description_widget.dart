import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timotime/viewmodels/session_viewmodel.dart';

class TaskDescriptionWidget extends StatelessWidget {
  const TaskDescriptionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionViewmodel>();
    return Row(
      children: [
        Icon(
          Icons.checklist,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Current Task",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              session.task.isNotEmpty ? session.task : "No task selected",
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
