import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'viewmodels/timer_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(640, 950),
    center: true,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimerViewmodel()),
      ],
      child: const Timotime(),
    ),
  );
}

class Timotime extends StatelessWidget {
  const Timotime({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFBD2A32), // <-- ton rouge
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          actions: [
            OutlinedButton.icon(
              onPressed: () {},
              label: const Text('New Session'),
              icon: const Icon(Icons.add),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
          ],
        ),
        body: Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double maxWidth =
                  constraints.maxWidth > 400 ? 400 : constraints.maxWidth * 0.8;
              return SizedBox(
                width: maxWidth,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const AppIcon(),
                  const SizedBox(height: 50),
                  const ProgressStep(),
                  const SizedBox(height: 30),
                  const TimerWidget(),
                  const SizedBox(height: 30),
                  TaskWidget()
                ]),
              );
            },
          ),
        ),
      ),
    );
  }
}

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

class TaskDescriptionWidget extends StatelessWidget {
  const TaskDescriptionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
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

class CheckedButtonProgressWidget extends StatelessWidget {
  final bool isChecked;

  const CheckedButtonProgressWidget({
    required this.isChecked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
      decoration: BoxDecoration(
        color: isChecked
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondaryContainer,
        shape: BoxShape.circle,
      ),
      child: isChecked
          ? Center(
              child: Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : null,
    );
  }
}

class SessionProgressTitle extends StatelessWidget {
  const SessionProgressTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Session Progress',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

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
        print('Selected: $selected');
      },
    );
  }
}

class AppIcon extends StatelessWidget {
  const AppIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/timoti.png',
      fit: BoxFit.cover,
      width: 150,
      height: 150,
    );
  }
}

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
          print('Timer stopped');
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

class StartPauseButton extends StatelessWidget {
  const StartPauseButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final timerVM = context.watch<TimerViewmodel>();

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: _buildButton(timerVM, context),
    );
  }

  Widget _buildButton(TimerViewmodel timerVM, context) {
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
            print('Timer ${timerVM.isRunning ? 'paused' : 'started'}');
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
            print('Timer ${timerVM.isRunning ? 'paused' : 'started'}');
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
