part of 'notifications_cubit.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}


class GetNotificationsLoadingState extends NotificationsState {}
class GetNotificationsLoadedState extends NotificationsState {
  final List<Notification> notifications;

  const GetNotificationsLoadedState({required this.notifications});
}
class GetNotificationsErrorState extends NotificationsState {
  final String message;

  const GetNotificationsErrorState({required this.message});
}

class MarkNotificationAsReadLoadingState extends NotificationsState {}
class  MarkNotificationAsReadLoadedState extends NotificationsState {
  final String message;

  const  MarkNotificationAsReadLoadedState({required this.message});
}
class MarkNotificationAsReadErrorState extends NotificationsState {
  final String message;

  const MarkNotificationAsReadErrorState({required this.message});
}

class HasMoreNotificationsNotReadedState extends NotificationsState {}

class HasNotMoreNotificationsNotReadedState extends NotificationsState {}

class CheckIfHasMoreNotificationsNotReadedState extends NotificationsState {
  final int notReadedNotificationsCount;

  const CheckIfHasMoreNotificationsNotReadedState(
      {required this.notReadedNotificationsCount});
}