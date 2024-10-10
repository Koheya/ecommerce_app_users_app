import 'package:ecommerce/services/assets_manager.dart';
import 'package:ecommerce/widgets/title_text.dart';
import 'package:flutter/material.dart';

class MyAppMethods {
  static Future<dynamic> showErrorOrWarningDialog({
    required BuildContext context,
    required String title,
    required String msg,
    required Function fct,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AssetsManager.warning,
                height: 60,
                width: 60,
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  title,
                ),
              ),
            ],
          ),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                fct();
                Navigator.pop(context);
              },
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  static Future<void> imagePickerDialog({
    required BuildContext context,
    required Function cameraFun,
    required Function galleryFun,
    required Function removeFun,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: const TitleTextWidget(label: 'Choose an option'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                onPressed: () {
                  cameraFun();
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.camera),
                label: const Text('Camera'),
              ),
              TextButton.icon(
                onPressed: () {
                  galleryFun();
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.image),
                label: const Text('Gallery'),
              ),
              TextButton.icon(
                onPressed: () {
                  removeFun();
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.remove),
                label: const Text('Remove'),
              ),
            ],
          ),
        );
      },
    );
  }
}
