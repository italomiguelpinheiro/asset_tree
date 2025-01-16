import 'package:asset_tree/app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;

  const ErrorDialog({
    Key? key,
    this.title = "Error",
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Icon(
        Icons.error_outline_outlined,
        color: Colors.red,
        size: 40,
      ),
      content: Text(
        message,
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            "OK",
            style: TextStyle(color: CustomColors.primary),
          ),
        ),
      ],
    );
  }
}
