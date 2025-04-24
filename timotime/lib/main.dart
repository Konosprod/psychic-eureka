import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timotime/services/settings_service.dart';
import 'package:timotime/viewmodels/session_viewmodel.dart';
import 'package:timotime/viewmodels/settings_viewmodel.dart';
import 'package:timotime/views/home/home_page.dart';
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
        ChangeNotifierProvider(create: (_) => SessionViewmodel()),
        ChangeNotifierProvider(
            create: (_) => SettingsViewModel(SettingsService())..load()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFFBD2A32), // <-- ton rouge
          ),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    ),
  );
}
