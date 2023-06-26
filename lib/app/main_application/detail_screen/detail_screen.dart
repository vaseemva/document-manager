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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Document Details'),
        backgroundColor: Colors.grey.shade200,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Card(
            elevation: 10,
            color: Colors.white,
            child: Container(
              height: size.height * 0.65,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: ListView(
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
                          color:
                              Colors.red.shade300, // Customize the icon color
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Open File Button
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await OpenFile.open(file.path);
                            } catch (e) {
                              log(e.toString());
                            }
                          },
                          child: const Text('Open File'),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      //edit button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditScreen(document: file),
                            ));
                          },
                          child: const Text('Edit Details'),
                        ),
                      ),
                    ],
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 8.0),
                          Text(
                            'Expiry Date: ',
                            style: const TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                      Text(
                        file.expirydate != null
                            ? DateFormat('MMM dd, yyyy hh:mm a')
                                .format(file.expirydate!)
                            : "Not Set",
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getDocumentIcon(FileModel file) {
    if (file.type == '.pdf') {
      return Icons.picture_as_pdf;
    } else if (file.type == '.png' ||
        file.type == '.jpg' ||
        file.type == '.jpeg') {
      return Icons.image;
    } else if (file.type == '.xls' || file.type == '.xlsx') {
      return Icons.insert_drive_file;
    } else {
      return Icons.insert_drive_file;
    }
  }
}
