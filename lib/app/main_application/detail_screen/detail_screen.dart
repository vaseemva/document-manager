import 'dart:developer';

import 'package:document_manager_app/app/class/file_model.dart';
import 'package:document_manager_app/app/main_application/edit_screen/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';

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
          const SizedBox(
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
            child: const Text('Open File'),
          ),
          const SizedBox(
            height: 10,
          ),
          //edit button
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditScreen(document: file),
              ));
            },
            child: const Text('Edit Details'),
          ),
          const SizedBox(
            height: 10,
          ),
          // File Name
          Row(
            children: [
              const Icon(Icons.insert_drive_file),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  'File Name: ${file.name}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // File Description
          const Row(
            children: [
              Icon(Icons.description),
              SizedBox(width: 8.0),
              Text(
                'File Description:',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          Text(
            file.description,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 16.0),
          ),

          const SizedBox(height: 8.0),

          // File Type
          Row(
            children: [
              const Icon(Icons.folder),
              const SizedBox(width: 8.0),
              Text(
                'File Type: ${file.type}',
                style: const TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // Expiry Date
          Row(
            children: [
              const Icon(Icons.calendar_today),
              const SizedBox(width: 8.0),
              Text(
                'Expiry Date: ${file.expirydate != null ? DateFormat('MMM dd, yyyy hh:mm a').format(file.expirydate!) : "Not Set"}',
                style: const TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
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
