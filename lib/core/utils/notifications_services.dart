import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

int id = 0;
const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
final List<DarwinNotificationCategory> darwinNotificationCategories =
    <DarwinNotificationCategory>[
  DarwinNotificationCategory(
    darwinNotificationCategoryText,
    actions: <DarwinNotificationAction>[
      DarwinNotificationAction.text(
        'text_1',
        'Action 1',
        buttonTitle: 'Send',
        placeholder: 'Placeholder',
      ),
    ],
  ),
  DarwinNotificationCategory(
    darwinNotificationCategoryPlain,
    actions: <DarwinNotificationAction>[
      DarwinNotificationAction.plain('id_1', 'Action 1'),
      DarwinNotificationAction.plain(
        'id_2',
        'Action 2 (destructive)',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.destructive,
        },
      ),
      DarwinNotificationAction.plain(
        navigationActionId,
        'Action 3 (foreground)',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
      DarwinNotificationAction.plain(
        'id_4',
        'Action 4 (auth required)',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.authenticationRequired,
        },
      ),
    ],
    options: <DarwinNotificationCategoryOption>{
      DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
    },
  )
];

final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
  requestAlertPermission: false,
  requestBadgePermission: false,
  requestSoundPermission: false,
  onDidReceiveLocalNotification:
      (int id, String? title, String? body, String? payload) async {
    didReceiveLocalNotificationStream.add(
      ReceivedNotification(
        id: id,
        title: title,
        body: body,
        payload: payload,
      ),
    );
  },
  notificationCategories: darwinNotificationCategories,
);

final InitializationSettings initializationSettings = InitializationSettings(
  android: initializationSettingsAndroid,
  iOS: initializationSettingsDarwin,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

const String portName = 'notification_send_port';

const DarwinNotificationDetails iosNotificationDetails =
    DarwinNotificationDetails(
  categoryIdentifier: darwinNotificationCategoryPlain,
);

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload;

Future<NotificationAppLaunchDetails?> getNotificationAppLaunchDetails() async {
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  return notificationAppLaunchDetails;
}

const String urlLaunchActionId = 'id_1';
const String navigationActionId = 'id_3';
const String darwinNotificationCategoryText = 'textCategory';
const String darwinNotificationCategoryPlain = 'plainCategory';

AndroidNotificationChannel androidChannel = const AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
  playSound: true,
  enableVibration: true,
);

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    debugPrint(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

/// Start foreground service
Future<void> startForegroundService() async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.startForegroundService(1, 'plain title', 'plain body',
          notificationDetails: androidNotificationDetails, payload: 'item x');
}

/// Start foreground service with blue background
Future<void> startForegroundServiceWithBlueBackgroundNotification() async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    androidChannel.id,
    androidChannel.name,
    channelDescription: 'color background channel description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    color: Colors.blue,
    colorized: true,
    sound: const RawResourceAndroidNotificationSound('slow_spring_board'),
  );
}

/// Setup all notification channels , services  and permissions
initializeNotifications() async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidChannel);
  startForegroundService();
  startForegroundServiceWithBlueBackgroundNotification();
  bool _notificationsEnabled = false;
  if (Platform.isAndroid) {
    final bool granted = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        false;

    _notificationsEnabled = granted;
  }
  if (Platform.isIOS || Platform.isMacOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
          critical: true,
        );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
          critical: true,
        );
  } else if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final bool? granted = await androidImplementation?.requestNotificationsPermission();
    _notificationsEnabled = granted ?? false;
  }

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      didReceiveLocalNotificationStream.add(
        ReceivedNotification(
          payload: notificationResponse.payload,
          id: 0,
          title: '',
          body: '',
        ),
      );
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == navigationActionId) {
            selectNotificationStream.add(notificationResponse.payload);
          }
          break;
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  // i want to navigate to a specific page when the user taps on the notification
}

class NotificationsServices {
  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    log('$title $body', name: 'notification shown');
    AndroidNotification android = const AndroidNotification();
    flutterLocalNotificationsPlugin.show(
        id++,
        title,
        body,
        NotificationDetails(
            iOS: const DarwinNotificationDetails(),
            android: AndroidNotificationDetails(
              androidChannel.id,
              androidChannel.name,
              channelDescription: androidChannel.description,
              importance: Importance.high,
              playSound: true,
              icon: android.smallIcon,
            )));
    log('notification shown', name: 'notification shown');
  }
}
