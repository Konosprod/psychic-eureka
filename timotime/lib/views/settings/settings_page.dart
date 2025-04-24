import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timotime/viewmodels/settings_viewmodel.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsVM = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double maxWidth =
                constraints.maxWidth > 400 ? 400 : constraints.maxWidth * 0.8;
            var inputBreakDuration = TextEditingController(
                text: settingsVM.shortBreakTime.toString());
            var inputLongBreakDuration = TextEditingController(
              text: settingsVM.longBreakTime.toString(),
            );
            var inputWorkDuration = TextEditingController(
              text: settingsVM.workTime.toString(),
            );
            return SizedBox(
              width: maxWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time Settings',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Work Duration',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: 'Enter work duration in minutes',
                            ),
                            keyboardType: TextInputType.number,
                            controller: inputWorkDuration,
                            autovalidateMode: AutovalidateMode.always,
                            validator: validateInputeDurationValue,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Small Break Duration',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: 'Enter break duration in minutes',
                            ),
                            keyboardType: TextInputType.number,
                            controller: inputBreakDuration,
                            autovalidateMode: AutovalidateMode.always,
                            validator: validateInputeDurationValue,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Long Break Duration',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: 'Enter long break duration in minutes',
                            ),
                            keyboardType: TextInputType.number,
                            controller: inputLongBreakDuration,
                            autovalidateMode: AutovalidateMode.always,
                            validator: validateInputeDurationValue,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () async {
                              settingsVM.workTime =
                                  int.parse(inputWorkDuration.text);
                              settingsVM.shortBreakTime =
                                  int.parse(inputBreakDuration.text);
                              settingsVM.longBreakTime =
                                  int.parse(inputLongBreakDuration.text);

                              await settingsVM.save();

                              // Save settings logic here
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Settings saved!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.save,
                                color: Theme.of(context).colorScheme.onPrimary),
                            label: Text('Save Settings',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Divider(
                            height: 40,
                          ),
                          Text(
                            'Data',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                onPressed: () {},
                                label: Text('Delete Data',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary)),
                                icon: Icon(Icons.delete,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.tertiary,
                                ),
                                onPressed: () {},
                                label: Text('Export Data',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiary)),
                                icon: Icon(Icons.download,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String? validateInputeDurationValue(value) {
    if (value == null ||
        value.isEmpty ||
        int.tryParse(value) == null ||
        int.tryParse(value)! <= 0) {
      return 'Please enter a duration greater than 0';
    }

    if (int.tryParse(value)! > 60) {
      return 'Please enter a duration less than or equal to 60';
    }
    return null;
  }
}
