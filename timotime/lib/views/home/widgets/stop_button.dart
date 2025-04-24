import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timotime/viewmodels/timer_viewmodel.dart';

class StopButton extends StatelessWidget {
  const StopButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final timerVM = context.watch<TimerViewmodel>();

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: OutlinedButton.icon(
        iconAlignment: IconAlignment.start,
        style: OutlinedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          fixedSize: const Size(120, 50),
          elevation: 2,
        ),
        onPressed: () {
          timerVM.stopTime();
        },
        label: Text("Stop",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
            )),
        icon: Icon(
          Icons.stop,
          color: Theme.of(context)
              .colorScheme
              .onSecondary, // Change the icon color to white // Change the icon size to 30
        ),
      ),
    );
  }
}
