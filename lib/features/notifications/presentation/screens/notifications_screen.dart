import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstore/core/utils/app_localization_strings.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/core/widgets/screen_container.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../cubit/notifications_cubit.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
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
  void initState() {
    super.initState();
    _getNotifications();
  }

  // @override
  // void deactivate() {
  //   super.deactivate();
  //   _getNotifications();
  // }

  @override
  Widget build(BuildContext context) {
    var translator = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: Constants.getAppBar(context,
            title: translator.translate(AppLocalizationStrings.notifications)!),
        body: buildNotifications(context));
  }

  buildNotifications(BuildContext context) {
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is GetNotificationsLoadingState) {
          return const LoadingIndicator();
        }
        if (context.read<NotificationsCubit>().notifications.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemCount:
                    context.read<NotificationsCubit>().notifications.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: context
                                .read<NotificationsCubit>()
                                .notifications[index]
                                .readAt !=
                            null
                        ? Colors.white
                        : Colors.grey[200],
                    child: ListTile(
                      onTap: () {
                        context
                            .read<NotificationsCubit>()
                            .markNotificationAsRead(
                                id: context
                                    .read<NotificationsCubit>()
                                    .notifications[index]
                                    .id!);
                        _getNotifications();
                      },
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(context
                          .read<NotificationsCubit>()
                          .notifications[index]
                          .message!),
                      titleTextStyle: Theme.of(context).textTheme.titleLarge,
                    ),
                  );
                }),
          );
        } else {
          return const Center(
            child: Text('No Notifications Yet'),
          );
        }
      },
    );
  }
}
