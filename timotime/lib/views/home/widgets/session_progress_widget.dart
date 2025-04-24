import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timotime/viewmodels/timer_viewmodel.dart';
import 'package:timotime/views/home/widgets/checked_button_progress_widget.dart';

class SessionProgressWidget extends StatelessWidget {
  const SessionProgressWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final timerVM = context.watch<TimerViewmodel>();
    final currentStep = timerVM.workStep;
    final maxSteps = timerVM.workSteps;
    final progressPercent = timerVM.progressPercent;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$currentStep/$maxSteps  Pomodoros",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Text(
                    "$progressPercent%",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progressPercent / 100,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            color: Theme.of(context).colorScheme.primary,
            minHeight: 10,
          ),
        ),
        Row(
          children: [
            for (int i = 0; i < maxSteps; i++)
              CheckedButtonProgressWidget(isChecked: i < currentStep),
          ],
        ),
      ],
    );
  }
}
