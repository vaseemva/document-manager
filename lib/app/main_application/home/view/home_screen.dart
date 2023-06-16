import 'package:document_manager_app/app/class/file_model.dart';
import 'package:document_manager_app/app/main_application/add_document/view/add_screen.dart';
import 'package:document_manager_app/app/main_application/detail_screen/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<FileModel> _fileBox;

  @override
  void initState() {
    _fileBox = Hive.box<FileModel>('files');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Document Manager"),
      ),
      body: ValueListenableBuilder(
        valueListenable: _fileBox.listenable(),
        builder: (context, box, child) {
          final files = box.values.toList().cast<FileModel>();
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (context, index) {
              final file = files[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DetailScreen(file: file),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getDocumentIcon(file),
                              size: 48.0,
                              color: Colors.red.shade300, // Customize the icon color
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              file.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )),
              );
            },
            itemCount: files.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddScreen(),
            ));
          },
          label: const Icon(Icons.add)),
    );
  }
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
