import 'package:flutter/material.dart';

void showLoadingDialog(
    {required BuildContext context, required String text}) async {
  showDialog(
    // The user CANNOT close this dialog  by pressing outsite it
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  width: 16.0,
                ),
                Text(text),
              ],
            ),
          ),
        ),
      );
    },
  );
}
