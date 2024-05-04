import 'dart:developer';
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:kstore/core/api/cach_helper.dart';
import 'package:kstore/core/api/end_points.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/utils/app_strings.dart';
import 'package:kstore/core/utils/notifications_services.dart';

import 'package:kstore/features/notifications/data/models/notification_model.dart';
// import 'package:pusher_client/pusher_client.dart';
import 'package:kstore/restart_app.dart';

import 'app.dart';
import 'bloc_observer.dart';
import 'injection_container.dart' as di;
import 'package:kstore/core/utils/notifications_services.dart'
    as notification_services;

// Initialize pusher_client to listen to events
void initializePusher() {
  // PusherClient pusher = PusherClient(
  //   PusherConfig.appKey,
  //   autoConnect: false,
  //   PusherOptions(
  //     cluster: PusherConfig.cluster,
  //     encrypted: PusherConfig.encrypted,
  //     pongTimeout: PusherConfig.pongTimeout,
  //     // auth: PusherAuth(
  //     //   EndPoints.notificationsBroadcastingAuth,
  //     //   headers: {
  //     //     "Content-Type": 'application/json',
  //     //     'APILang': 'en',
  //     //     AppStrings.authorization:
  //     //         'Bearer ${CacheHelper.getData(key: AppStrings.token)}',
  //     //     'Accept': 'application/json',
  //     //   },
  //   ),
  //   // ),
  //   // enableLogging: true,
  // );

  // Channel channel = pusher.subscribe(
  //     'private-App.Models.User.14'); //TODO: change channel name to be dynamic id
  // pusher.connect();

  // pusher.onConnectionStateChange((state) {
  //   log("previousState: ${state!.previousState}, currentState: ${state.currentState}");
  //   NotificationsServices.showNotification(
  //     title: 'Our Your Order',
  //     body: 'state: ${state.currentState}',
  //     payload: 'payload',
  //   );
  // });

  // pusher.onConnectionError((error) {
  //   log("error: ${error!.message}");
  // });

  // channel.bind('status-update', (event) {
  //   log(event!.data!);
  // });

  // channel.bind('order-filled', (event) {
  //   log("Order Filled Event${event!.data}");
  // });

  // channel
  //     .bind("Illuminate\\Notifications\\Events\\BroadcastNotificationCreated",
  //         (event) {
  //   log("KSTORE back-end: ${event!.data}");
  //   var jsonNotification = jsonDecode(event.data!);
  //   var notification = NotificationModel.fromJson(jsonNotification);
  //   //push notification to the device
  //   NotificationsServices.showNotification(
  //     title: 'Our Your Order',
  //     body: '${event.data}',
  //     payload: 'payload',
  //   );

  //   log("KSTORE back-end: $notification");
  // });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey = StripKeys.PUBLISHABLE_KEY;

  // if (!kIsWeb) {
  await notification_services.initializeNotifications();
  // await Firebase.initializeApp();
  // await fb.config();
  // }

  await di.init();
  await CacheHelper.init();
  // Bloc.observer = AppBlocObserver();
  //! test case
  // final apiListener = APIListener();
  // apiListener.startListening();
  // apiListener.dataStream.listen((data) {
  //   // Handle received data here
  //   print('Received data: $data');
  // }, onError: (error) {
  //   // Handle errors here
  //   print('Error occurred: $error');
  // });

  //!end test case
  // initializePusher();//when i add this line i
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    Bloc.observer = AppBlocObserver();
    runApp(
      const RestartWidget(
        child: KStoreApp(),
      ),
    );
  });
}

class APIListener {
  final _controller = StreamController<dynamic>();

  Stream<dynamic> get dataStream => _controller.stream;

  void startListening() {
    Timer.periodic(const Duration(hours: 5), (Timer t) {
      Dio()
          .get(EndPoints.notifications,
              queryParameters: {
                'page': 1,
                'per_page': 500,
              },
              options: Options(
                method: 'GET',
                headers: {
                  "Content-Type": 'application/json',
                  'APILang': 'en',
                  AppStrings.authorization:
                      'Bearer ${CacheHelper.getData(key: AppStrings.token)}',
                  'Accept': 'application/json',
                },
              ))
          .then((response) {
        BaseResponse baseResponse = BaseResponse();
        var jsonResponse = response.data;
        Iterable iterable = jsonResponse['data'];
        baseResponse.data =
            iterable.map((model) => NotificationModel.fromJson(model)).toList();

        List<NotificationModel> notifications = [];
        notifications = baseResponse.data;

        if (notifications.isNotEmpty) {
          for (var element in notifications) {
            if (element.readAt == null) {
              NotificationsServices.showNotification(
                title: 'Our Your Order',
                body: '${element.message}',
                payload: 'payload',
              );
            }
          }
        }

        log("KSTORE back-end: ${baseResponse.data}");
      }).catchError((error) {
        _controller.addError(error);
        log("KSTORE ERROR: $error");
      });
    });
  }

  void stopListening() {
    _controller.close();
  }
}
