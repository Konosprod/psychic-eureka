import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timotime/services/notification_service.dart';
import 'package:timotime/viewmodels/timer_viewmodel.dart';

class StartPauseButton extends StatelessWidget {
  const StartPauseButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final timerVM = context.watch<TimerViewmodel>();
    final NotificationService notificationService =
        context.read<NotificationService>();

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: _buildButton(timerVM, context, notificationService),
    );
  }

  Widget _buildButton(TimerViewmodel timerVM, context,
      NotificationService notificationService) {
    var label = timerVM.isRunning ? "Pause" : "Start";
    var icon = timerVM.isRunning ? Icons.pause : Icons.play_arrow;
    var color = timerVM.isRunning
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.primary;
    var textColor = timerVM.isRunning
        ? Theme.of(context).colorScheme.onSecondary
        : Theme.of(context).colorScheme.onPrimary;

    if (!timerVM.isRunning) {
      return ElevatedButton.icon(
          iconAlignment: IconAlignment.start,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            elevation: 4,
            fixedSize: const Size(120, 50),
          ),
          onPressed: () {
            timerVM.isRunning ? timerVM.pauseTime() : timerVM.startTime();
          },
          label: Text(
            label,
            style: TextStyle(color: textColor),
          ),
          icon: Icon(
            icon,
            color: textColor,
          ));
    } else {
      return OutlinedButton.icon(
          iconAlignment: IconAlignment.start,
          style: ElevatedButton.styleFrom(
            // backgroundColor: color,
            fixedSize: const Size(120, 50),
          ),
          onPressed: () {
            timerVM.isRunning ? timerVM.pauseTime() : timerVM.startTime();
          },
          label: Text(
            label,
            // style: TextStyle(color: textColor),
          ),
          icon: Icon(
            icon,
            // color: textColor,
          ));
    }
  }
}
