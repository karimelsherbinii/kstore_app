// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import '../../config/locale/app_localizations.dart';
import '../../config/routes/app_routes.dart';
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../utils/app_colors.dart';

class NotificationLabelAlert extends StatefulWidget {
  final Color? notificationColor;
  const NotificationLabelAlert({super.key, this.notificationColor});

  @override
  State<NotificationLabelAlert> createState() => _NotificationLabelAlertState();
}

class _NotificationLabelAlertState extends State<NotificationLabelAlert> {
  @override
  void initState() {
    super.initState();
    _getNotifications();
  }

  _getNotifications() async {
    BlocProvider.of<NotificationsCubit>(context).clearNotifications();
    await BlocProvider.of<NotificationsCubit>(context)
        .getNotifications()
        .then((value) => _checkIfHasMoreNotificationsNotReaded());
  }

  _checkIfHasMoreNotificationsNotReaded() async {
    await BlocProvider.of<NotificationsCubit>(context)
        .checkIfHasMoreNotificationsNotReaded();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        var translator = AppLocalizations.of(context)!;
        int notReadedNotificationsCount =
            context.read<NotificationsCubit>().notReadedNotificationsCount;
        debugPrint('notReadedNotificationsCount: $notReadedNotificationsCount');
        if (state is GetNotificationsLoadingState) {
          return Container();
        }
        return SizedBox(
          width: 70,
          height: 40,
          child: Stack(
            children: [
              Positioned(
                left: translator.isArLocale ? 0 : null,
                right: translator.isArLocale ? null : 0,
                bottom: 5,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.notificationsScreen);
                  },
                  child: Icon(
                    Icons.notifications,
                    size: 30,
                    color: widget.notificationColor ?? AppColors.primaryColor,
                  ),
                ),
              ),
              if (notReadedNotificationsCount > 0 &&
                  state is! GetNotificationsLoadingState)
                Positioned(
                  left: translator.isArLocale ? 18 : null,
                  right: !translator.isArLocale ? 18 : null,
                  top: 0,
                  child: notReadedNotificationsCount > 0
                      ? Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(7),
                              child: Text(
                                notReadedNotificationsCount > 10
                                    ? '+10'
                                    : notReadedNotificationsCount.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                )
              // else
              //   Container()
            ],
          ),
        );
      },
    );
  }
}
