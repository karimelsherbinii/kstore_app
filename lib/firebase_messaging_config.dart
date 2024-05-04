    import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'core/utils/notifications_services.dart';

config() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    log('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    log('User granted provisional permission');
  } else {
    log('User declined or has not accepted permission');
  }

  messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) {
      //stop notification from firebase
      log('Got a message whilst in the foreground!', name: 'foreground');
      log('Message data: ${message.data}', name: 'inside config');
      log(message.data['title'] ?? "no title", name: 'title');
      _showNotification(message);
    },
  );

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    log('Got a message whilst in the foreground!', name: 'foreground');
    log('Message data: ${message.data}', name: 'inside config');
    _showNotification(message);
  });

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingHandler);
}

Future<void> firebaseMessagingHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('Handling a Background message ${message.messageId}', name: 'background');
  log('Message data: ${message.data}', name: 'inside config');

  _showNotification(
      message); // if you want to show notification in background with [Data message type only]
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Got a message whilst in the foreground!', name: 'foreground');
    log('Message data: ${message.data}', name: 'inside config');
    log(message.data['title'] ?? "no title", name: 'title');
    _showNotification(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    log('Got a message whilst in the foreground!', name: 'foreground');
    log('Message data: ${message.data}', name: 'inside config');
    _showNotification(message);
  });
}

//? -------------------------------------------- [local notification] -------------------------------------------- //
void _showNotification(RemoteMessage message) {
  log('${message.data['title']}', name: 'title inside _showNotification');
  if (message.notification != null) {
    RemoteNotification notification =
        message.notification ?? const RemoteNotification();
    AndroidNotification android =
        message.notification!.android ?? const AndroidNotification();

    flutterLocalNotificationsPlugin.show(
        message.data.hashCode,
        notification.title,
        notification.body,
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
    log('Message also contained a notification: ${message.notification}');
  }
}
