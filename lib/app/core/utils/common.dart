import 'package:document_manager_app/app/class/file_model.dart';
import 'package:flutter/material.dart';

IconData getDocumentIcon(FileModel file) {
  if (file.type == '.pdf') {
    return Icons.picture_as_pdf;
  } else if (file.type == '.png' ||
      file.type == '.jpg' ||
      file.type == '.jpeg') {
    return Icons.image;
  } else if (file.type == '.xls'||file.type=='.xlsx') {
    return Icons.insert_drive_file;
  } else {
    return Icons.insert_drive_file;
  }
}
