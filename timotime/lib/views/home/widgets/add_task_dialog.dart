import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timotime/viewmodels/session_viewmodel.dart';
import 'package:timotime/viewmodels/timer_viewmodel.dart';

class AddTaskDialog extends StatelessWidget {
  const AddTaskDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final sessionVM = context.watch<SessionViewmodel>();
    final timerVM = context.watch<TimerViewmodel>();

    var taskInputController = TextEditingController();
    return AlertDialog(
      title: const Text('New Task'),
      content: SizedBox(
        width: 300,
        child: InputDecorator(
          decoration: InputDecoration(
            hintText: 'Enter Task',
          ),
          child: TextFormField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Task Name',
            ),
            controller: taskInputController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validateTaskInput,
          ),
        ),
      ),
      actions: [
        TextButton.icon(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            // Add your task creation logic here
            String taskName = taskInputController.text;
            sessionVM.updateTask(taskName);
            timerVM.stopTime();
            SnackBar snackBar = SnackBar(
              content: Text('Task "$taskName" created!'),
              duration: const Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          label: Text(
            'Create',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        TextButton.icon(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.cancel_outlined,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          label: Text(
            'Cancel',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
      ],
    );
  }

  String? validateTaskInput(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a task name';
    }

    if (value.length >= 255) {
      return 'Task name is too long, maximum 255 characters';
    }

    return null;
  }
}
