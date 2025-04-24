import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timotime/viewmodels/timer_viewmodel.dart';
import 'package:timotime/views/home/widgets/start_pause_button.dart';
import 'package:timotime/views/home/widgets/stop_button.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timerVM = context.watch<TimerViewmodel>();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.only(top: 30, bottom: 20, left: 60, right: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                timerVM.formattedTime,
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 8,
              runSpacing: 8,
              children: [
                StartPauseButton(),
                StopButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
