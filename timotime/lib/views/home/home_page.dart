import 'package:flutter/material.dart';
import 'package:timotime/views/home/widgets/add_task_dialog.dart';
import 'package:timotime/views/home/widgets/progress_step.dart';
import 'package:timotime/views/home/widgets/task_widget.dart';
import 'package:timotime/views/home/widgets/timer_widget.dart';
import 'package:timotime/views/settings/settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
              icon: const Icon(Icons.settings))
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
                TaskWidget(),
              ]),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        tooltip: 'New Task',
        onPressed: () {
          showDialog(context: context, builder: (context) => AddTaskDialog());
        },
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      ),
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
