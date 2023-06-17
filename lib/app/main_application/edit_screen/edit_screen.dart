import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:document_manager_app/app/class/file_model.dart';
import 'package:document_manager_app/app/core/utils/consts.dart';
import 'package:document_manager_app/app/main_application/home/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, required this.document});
  final FileModel document;
  @override
  EditScreenState createState() => EditScreenState();
}

class EditScreenState extends State<EditScreen> {
  @override
  void initState() {
    _nameController.text = widget.document.name;
    _desController.text = widget.document.description;
    _expiryDateTime = widget.document.expirydate;
    _selectedDocumentType = widget.document.type;

    super.initState();
  }

 

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _desController = TextEditingController();

  String? _selectedDocumentType;
  final List<String> _documentTypes = [
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
    if (_desController.text.isEmpty || _nameController.text.isEmpty) {
      AnimatedSnackBar.material("Please fill the required fields",
              type: AnimatedSnackBarType.error,
              mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              duration: const Duration(seconds: 1))
          .show(context);
    }

    if (_desController.text.isNotEmpty && _nameController.text.isNotEmpty) {
      FileModel document = FileModel(
          name: _nameController.text,
          description: _desController.text,
          path: widget.document.path,
          type: _selectedDocumentType,
          expirydate: _expiryDateTime);

      final box = Hive.box<FileModel>('files');
      final files = box.values.toList();

      for (var i = 0; i < files.length; i++) {
        if (files[i].id == widget.document.id) {
          await box.putAt(i, document);

          // ignore: use_build_context_synchronously
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false,
          );
          // ignore: use_build_context_synchronously
          AnimatedSnackBar.material("File Updated Successfully",
                  type: AnimatedSnackBarType.success,
                  duration: const Duration(seconds: 1))
              .show(context);
        }
      }

      setState(() {
        _desController.clear();
        _nameController.clear();
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
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.document.path,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))),
              ),
              kheight15,
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _desController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
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
