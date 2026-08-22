import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

const Duration _notificationDuration = Duration(seconds: 4);

/// The visual treatment for an application notification.
enum AppNotificationType {
  /// A standard notification without an icon.
  standard,

  /// An informational notification.
  info,

  /// An error notification.
  error,
}

/// Displays [message] as an application notification.
void showAppNotification(
  BuildContext context,
  String message, {
  AppNotificationType type = AppNotificationType.standard,
}) {
  toastification.dismissAll(delayForAnimation: false);
  toastification.show(
    context: context,
    title: Text(message),
    alignment: Alignment.bottomCenter,
    autoCloseDuration: _notificationDuration,
    style: ToastificationStyle.simple,
    type: switch (type) {
      AppNotificationType.standard => null,
      AppNotificationType.info => ToastificationType.info,
      AppNotificationType.error => ToastificationType.error,
    },
    showIcon: type != AppNotificationType.standard,
    showProgressBar: false,
    closeButton: const ToastCloseButton(showType: CloseButtonShowType.none),
    dragToClose: true,
    pauseOnHover: false,
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    borderRadius: BorderRadius.circular(999),
  );
}
