import 'package:document_manager_app/app/class/file_model.dart';
import 'package:document_manager_app/app/core/utils/common.dart';
import 'package:document_manager_app/app/main_application/add_document/view/add_screen.dart';
import 'package:document_manager_app/app/main_application/detail_screen/detail_screen.dart';
import 'package:document_manager_app/app/main_application/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Box<FileModel> _fileBox;

  @override
  void initState() {
    super.initState();
    _fileBox = Hive.box<FileModel>('files');
    _deleteExpiredFiles();
  }

  Future<void> _deleteExpiredFiles() async {
    final currentDate = DateTime.now();

    for (var i = 0; i < _fileBox.length; i++) {
      final file = _fileBox.getAt(i)!;
      if (file.expirydate != null) {
        final expirydate = file.expirydate;
        if (currentDate.isAfter(expirydate!)) {
          _fileBox.deleteAt(i);
        }
      }
    }
  }

  String calculateRemainingTime(DateTime expiryDate) {
    final now = DateTime.now();
    final remainingDuration = expiryDate.difference(now);

    if (remainingDuration.isNegative) {
      // Document has expired
      return 'Expired';
    }

    final remainingHours = remainingDuration.inHours;

    return 'Expiring in $remainingHours hours';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("Document Manager"),
        title: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SearchScreen(),
              ));
            },
            child: Icon(Icons.search )),
      ),
      body: ValueListenableBuilder(
        valueListenable: _fileBox.listenable(),
        builder: (context, box, child) {
          final files = box.values.toList().cast<FileModel>();
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
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
                              getDocumentIcon(file),
                              size: 48.0,
                              color: Colors
                                  .red.shade300, // Customize the icon color
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
                            file.expirydate != null
                                ? Text(
                                    calculateRemainingTime(file.expirydate!),
                                    style: const TextStyle(color: Colors.red),
                                  )
                                : const SizedBox()
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
              builder: (context) => const AddScreen(),
            ));
          },
          label: const Icon(Icons.add)),
    );
  }
}
