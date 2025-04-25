import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Initialisation des notifications pour Desktop (Windows, macOS, Linux)
    const InitializationSettings initializationSettings =
        InitializationSettings(
      macOS: DarwinInitializationSettings(),
      linux: LinuxInitializationSettings(defaultActionName: "Timotime"),
      windows: WindowsInitializationSettings(
          appName: "Timotime",
          appUserModelId: "Konosprod.Timotime",
          guid: "Timotime"),
    );

    print("Initialisation des notifications");
    // Initialiser le plugin avec les paramètres
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String message) async {
    // Configuration de la notification
    const NotificationDetails notificationDetails = NotificationDetails(
      macOS: DarwinNotificationDetails(),
      linux: LinuxNotificationDetails(),
      windows: WindowsNotificationDetails(),
    );

    // Affichage de la notification
    await flutterLocalNotificationsPlugin.show(
      0,
      'Timotime',
      message,
      notificationDetails,
    );
  }
}
