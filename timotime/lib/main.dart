import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timotime/services/settings_service.dart';
import 'package:timotime/viewmodels/session_viewmodel.dart';
import 'package:timotime/viewmodels/settings_viewmodel.dart';
import 'package:timotime/viewmodels/timer_viewmodel.dart';
import 'package:timotime/views/home/home_page.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // Initialisation fenêtre
  WindowOptions windowOptions = WindowOptions(
    size: Size(640, 950),
    center: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // ✅ Préparer les settings AVANT runApp
  final settingsService = SettingsService();
  final settingsViewModel = SettingsViewModel(settingsService);
  await settingsViewModel.load(); // <-- ici tu attends proprement

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => settingsViewModel),
        // ChangeNotifierProvider(
        //     create: (_) =>
        //         TimerViewmodel(settingsViewModel: settingsViewModel)),
        ChangeNotifierProvider(create: (_) => SessionViewmodel()),
        ChangeNotifierProxyProvider<SettingsViewModel, TimerViewmodel>(
          create: (_) => TimerViewmodel(settingsViewModel: settingsViewModel),
          update: (_, settingsViewModel, timerViewmodel) =>
              timerViewmodel!..initSteps(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFFBD2A32),
          ),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    ),
  );
}
