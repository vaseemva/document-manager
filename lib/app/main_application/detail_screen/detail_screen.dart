import 'dart:developer';

import 'package:document_manager_app/app/class/file_model.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatelessWidget {
  final FileModel file;

  const DetailScreen({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: Card(
              elevation: 2,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  _getDocumentIcon(file),
                  size: 100.0,
                  color: Colors.red.shade300, // Customize the icon color
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // Open File Button
          ElevatedButton(
            onPressed: () async {
              try {
                await OpenFile.open(file.path);
              } catch (e) {
                log(e.toString());
              }
            },
            child: Text('Open File'),
          ),
          SizedBox(
            height: 10,
          ),
          // File Name
          Row(
            children: [
              Icon(Icons.insert_drive_file),
              SizedBox(width: 8.0),
              Text(
                'File Name: ${file.name}',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          SizedBox(height: 8.0),

          // File Description
          Row(
            children: [
              Icon(Icons.description),
              SizedBox(width: 8.0),
              Text(
                'File Description: ${file.description}',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          SizedBox(height: 8.0),

          // File Type
          Row(
            children: [
              Icon(Icons.folder),
              SizedBox(width: 8.0),
              Text(
                'File Type: ${file.type}',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          SizedBox(height: 8.0),

          // Expiry Date
          Row(
            children: [
              Icon(Icons.calendar_today),
              SizedBox(width: 8.0),
              Text(
                'Expiry Date: ${file.expirydate ?? "Not Set"}',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }

  IconData _getDocumentIcon(FileModel file) {
    if (file.type == 'PDF') {
      return Icons.picture_as_pdf;
    } else if (file.type == 'PNG' || file.type == 'JPEG') {
      return Icons.image;
    } else if (file.type == 'XLSX') {
      return Icons.insert_drive_file;
    } else {
      return Icons.insert_drive_file;
    }
  }
}

void _openFile(FileModel file, BuildContext context) async {
  if (await canLaunch(file.path)) {
    await launch(file.path);
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Could not open the file.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
