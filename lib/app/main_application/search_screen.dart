import 'package:document_manager_app/app/class/file_model.dart';
import 'package:document_manager_app/app/main_application/detail_screen/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  List<FileModel> list = [];
  Box<FileModel>? _box;
  @override
  void initState() {
    _box = Hive.box<FileModel>('files');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            onChanged: (value) {
              list = _box!.values
                  .where((element) => element.name.contains(value))
                  .toList();
              setState(() {});
            },
          ),
        ),
        body: Visibility(
          visible: list.isNotEmpty,
          child: ListView.builder(
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailScreen(file: list[index]),
                ));
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(list[index].name),
                    Text(list[index].description)
                  ],
                ),
              ),
            ),
            itemCount: list.length,
          ),
        ));
  }
}
