import 'package:hive_flutter/hive_flutter.dart';
part 'file_model.g.dart';

@HiveType(typeId: 0)
class FileModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String description;
  @HiveField(3)
  String path;
  @HiveField(4)
  DateTime? expirydate;
  @HiveField(5)
  String? type;

  FileModel(
      {this.id,
      required this.name,
      required this.description,
      required this.path,
      this.expirydate,
      this.type});
}
