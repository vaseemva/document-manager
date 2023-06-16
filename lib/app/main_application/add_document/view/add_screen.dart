import 'dart:io';

import 'package:document_manager_app/app/class/file_model.dart';
import 'package:document_manager_app/app/core/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  FilePickerResult? _selectedFile;
  String _fileName = '';
  String _fileDescription = '';

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = result;
      });
    }
  }

  String? _selectedDocumentType;
  List<String> _documentTypes = [
    'PDF',
    'PNG',
    'JPEG',
    'XLSX',
  ];

  DateTime? _expiryDateTime;

  Future<void> _pickExpiryDateTime() async {
    final currentDate = DateTime.now();
    final initialDate = _expiryDateTime ?? currentDate;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: currentDate,
      lastDate: DateTime(currentDate.year + 10),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        setState(() {
          _expiryDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _saveFile() async {
    if (_selectedFile != null) {
      Directory appDirectory = await getApplicationDocumentsDirectory();
      String appFolderPath = appDirectory.path;
      String fileName = _selectedFile!.files.single.name;
      String filePath = '$appFolderPath/$fileName';

      File savedFile =
          await File(_selectedFile!.files.single.path!).copy(filePath);

      FileModel file = FileModel(
          name: _fileName,
          description: _fileDescription,
          path: savedFile.path,
          type: _selectedDocumentType,
          expirydate: _expiryDateTime);

      final box = Hive.box<FileModel>('files');
      await box.add(file);

      setState(() {
        _fileName = '';
        _fileDescription = '';
        _selectedFile = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Document'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              kheight15,
              Card(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: _selectedFile != null
                      ? Center(
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _selectedFile!.files.single.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                      : IconButton(
                          onPressed: () {
                            _selectFile();
                          },
                          icon: const Icon(Icons.upload)),
                ),
              ),
              kheight15,
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                onChanged: (value) {
                  setState(() {
                    _fileName = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                onChanged: (value) {
                  setState(() {
                    _fileDescription = value;
                  });
                },
              ),
              kheight20,
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Expiry Date'),
                subtitle: Text(
                  _expiryDateTime != null
                      ? DateFormat('MMM dd, yyyy hh:mm a')
                          .format(_expiryDateTime!)
                      : 'Not Set',
                ),
                onTap: _pickExpiryDateTime,
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Document Type'),
                trailing: const Icon(Icons.arrow_drop_down),
                subtitle: Text(
                  _selectedDocumentType ?? 'Select a document type',
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Select Document Type'),
                        content: DropdownButton<String>(
                          hint: const Text("Select"),
                          value: _selectedDocumentType,
                          items: _documentTypes.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedDocumentType = newValue;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 30.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveFile,
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
