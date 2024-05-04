import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/features/notifications/domain/entities/notification.dart';

import '../../../../core/usecases/usecase.dart';
import '../../data/models/notification_model.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notifications_as_read.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotifications getNotificationsUseCase;
  final MarkNotificationsAsRead markNotificationsAsReadUseCase;
  NotificationsCubit({
    required this.getNotificationsUseCase,
    required this.markNotificationsAsReadUseCase,
  }) : super(NotificationsInitial());

// List<Notification> get notifications => (state as GetNotificationsLoadedState).notifications;
  List<Notification> notifications = [];
  Future<void> getNotifications() async {
    emit(GetNotificationsLoadingState());
    final response = await getNotificationsUseCase(NoParams());
    response.fold(
        (failure) =>
            emit(GetNotificationsErrorState(message: failure.message!)),
        (response) {
      notifications = response.data;
      log('notifications: ${response.data}');
      emit(GetNotificationsLoadedState(notifications: response.data));
    });
  }

  int notReadedNotificationsCount = 0;
  checkIfHasMoreNotificationsNotReaded() async {
    notReadedNotificationsCount = 0;
    for (Notification notification in notifications) {
      if (notification.readAt == null) {
        notReadedNotificationsCount++;
      }
    }
    log('notReadedNotificationsCount: $notReadedNotificationsCount');
    emit(CheckIfHasMoreNotificationsNotReadedState(
        notReadedNotificationsCount: notReadedNotificationsCount));
  }

  Future<void> markNotificationAsRead({required String id}) async {
    emit(MarkNotificationAsReadLoadingState());
    final response = await markNotificationsAsReadUseCase(
        MarkNotificationsAsReadParams(id: id));
    response.fold(
        (failure) =>
            emit(MarkNotificationAsReadErrorState(message: failure.message!)),
        (data) {
      emit(MarkNotificationAsReadLoadedState(message: data.message ?? '1'));
    });
  }

  void clearNotifications() {
    notifications.clear();
  }
}
