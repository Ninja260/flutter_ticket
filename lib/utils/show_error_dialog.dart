import 'package:flutter/material.dart';

Future<bool?> showErrorDialog(
    {required BuildContext context,
    required String title,
    required String content}) async {
  bool? answer = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              inherit: true,
              color: Colors.red,
            ),
          ),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Okey',
              ),
            ),
          ]);
    },
  );

  return answer;
}
