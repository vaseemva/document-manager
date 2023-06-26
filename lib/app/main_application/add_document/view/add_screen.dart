import 'dart:developer';
import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:document_manager_app/app/class/file_model.dart';
import 'package:document_manager_app/app/core/utils/consts.dart';
import 'package:document_manager_app/app/main_application/add_document/widgets/permission_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  AddScreenState createState() => AddScreenState();
}

class AddScreenState extends State<AddScreen> {
  final formKey = GlobalKey<FormState>();
  FilePickerResult? _selectedFile;
  String _fileName = '';
  String _fileDescription = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _desController = TextEditingController();

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = result;
      });
    }
  }

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
    if (_fileDescription == '' || _fileName == '' || _selectedFile == null) {
      AnimatedSnackBar.material("Please fill the required fields",
              type: AnimatedSnackBarType.error,
              mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              duration: const Duration(seconds: 1))
          .show(context);
    }
    if (_selectedFile != null && _fileName != '' && _fileDescription != '') {
      Directory appDirectory = await getApplicationDocumentsDirectory();
      String appFolderPath = appDirectory.path;
      String fileName = _selectedFile!.files.single.name;
      String filePath = '$appFolderPath/$fileName';

      File savedFile =
          await File(_selectedFile!.files.single.path!).copy(filePath);

      String fileType = path.extension(_selectedFile!.files.single.path!);
      log(fileType);
      FileModel file = FileModel(
          id: DateTime.now().millisecondsSinceEpoch,
          name: _fileName,
          description: _fileDescription,
          path: savedFile.path,
          type: fileType,
          expirydate: _expiryDateTime);

      final box = Hive.box<FileModel>('files');
      await box.add(file);

      setState(() {
        _fileName = '';
        _fileDescription = '';
        _selectedFile = null;
        _desController.clear();
        _nameController.clear();
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      AnimatedSnackBar.material("File Saved Successfully",
              type: AnimatedSnackBarType.success,
              duration: const Duration(seconds: 1))
          .show(context);
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
          child: Form(
            key: formKey,
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
                            child: InkWell(
                            onTap: () async {
                              checkIfAlreadyAllowed();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _selectedFile!.files.single.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ))
                        : IconButton(
                            onPressed: () async {
                              checkIfAlreadyAllowed();
                            },
                            icon: const Icon(Icons.upload)),
                  ),
                ),
                Visibility(
                    visible: _selectedFile != null,
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await OpenFile.open(
                                        _selectedFile!.files.single.path!);
                                  } catch (e) {
                                    log(e.toString());
                                  }
                                },
                                child:const Text("Preview File")))
                      ],
                    )),
                kheight15,
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: (value) {
                    if (value == '') {
                      return "Please Enter Title";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      _fileName = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _desController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  validator: (value) {
                    if (value == '') {
                      return "Please Enter Description";
                    } else {
                      return null;
                    }
                  },
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
                const SizedBox(height: 30.0),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            _saveFile();
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  checkIfAlreadyAllowed() async {
    final preferences = await SharedPreferences.getInstance();
    if (preferences.getBool("button") == null) {
      preferences.setBool("button", true);
      PermissionStatus status = await Permission.storage.request();
      if (status.isGranted) {
        _selectFile();
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (context) => const StoragePermissionDialog());
      }
    } else if (preferences.getBool("button") == true) {
      PermissionStatus status = await Permission.storage.status;
      if (status.isGranted) {
        _selectFile();
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => const StoragePermissionDialog(),
        );
      }
    }
  }
}
