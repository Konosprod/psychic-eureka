import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timotime/viewmodels/timer_viewmodel.dart';

class ProgressStep extends StatelessWidget {
  const ProgressStep({super.key});

  @override
  Widget build(BuildContext context) {
    const segments = <ButtonSegment<PomodoroState>>[
      ButtonSegment<PomodoroState>(
        value: PomodoroState.work,
        label: Text('Work'),
      ),
      ButtonSegment<PomodoroState>(
        value: PomodoroState.shortBreak,
        label: Text('Short Break'),
      ),
      ButtonSegment<PomodoroState>(
        value: PomodoroState.longBreak,
        label: Text('Long Break'),
      ),
    ];

    final state = context.watch<TimerViewmodel>().state;

    Set<PomodoroState> selected = {state};
    return SegmentedButton(
      showSelectedIcon: false,
      segments: segments,
      selected: selected,
      onSelectionChanged: (Set<PomodoroState> newSelection) {
        selected = newSelection;
      },
    );
  }
}
