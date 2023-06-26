import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class StoragePermissionDialog extends StatelessWidget {
  const StoragePermissionDialog({super.key});

  void redirectToSettings(BuildContext context) {
    openAppSettings();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'For Saving and Accessing the file, the Document Manager app needs the storage permission. Kindly allow that from the settings.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => redirectToSettings(context),
              child: const Text('Open Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
