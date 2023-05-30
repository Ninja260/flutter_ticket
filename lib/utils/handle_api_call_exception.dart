import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ticket/exception/api_call_exception.dart';
import 'package:ticket/pages/user/login.dart';
import 'package:ticket/utils/logger.dart';
import 'package:ticket/utils/show_error_dialog.dart';

void handleApiCallException({
  required BuildContext context,
  required Object e,
  bool willPop = true,
}) {
  if (e is ApiCallException) {
    switch (e.httpStatus) {
      // will show error but stay on page
      case 400:
        showErrorDialog(
          context: context,
          title: e.title,
          content: e.message,
        );
        return;

      // show error and back one page
      case 403:
      case 422:
      case 500:
        showErrorDialog(
          context: context,
          title: e.title,
          content: e.message,
        ).then(
          (_) {
            if (willPop) Navigator.pop(context, 'refresh');
          },
        );
        return;

      // show error and reset the route stack with login page
      case 401:
      default:
        showErrorDialog(
          context: context,
          title: e.title,
          content: e.message,
        ).then(
          (_) {
            if (willPop) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                LoginPage.routeName,
                (route) => false,
              );
            }
          },
        );
        return;
    }
  }

  if (e is SocketException) {
    logger.e('hello', e);
    showErrorDialog(
      context: context,
      title: "Connection",
      content: "Cannot connect to the server. Please check the network",
    );
    return;
  }

  if (e is TimeoutException) {
    showErrorDialog(
      context: context,
      title: "Connnection",
      content: "Server is taking to too response.",
    );
    return;
  }

  logger.e('MONKEY_UNKNOWN_ERROR', e);
  showErrorDialog(
    context: context,
    title: "Unknown Error",
    content: "Unknow Error Occured!",
  ).then(
    (_) {
      if (willPop) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          LoginPage.routeName,
          (route) => false,
        );
      }
    },
  );
}
