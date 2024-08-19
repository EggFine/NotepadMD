import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileOperations {
  static Future<FileResult?> openFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      String content = await file.readAsString();
      return FileResult(content, file.path);
    }

    return null;
  }

  static Future<void> saveFile(String content, String? filePath) async {
    if (filePath == null) {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: 'Untitled.txt',
      );

      if (outputFile != null) {
        final File file = File(outputFile);
        await file.writeAsString(content);
      }
    } else {
      final File file = File(filePath);
      await file.writeAsString(content);
    }
  }
}

class FileResult {
  final String content;
  final String filePath;

  FileResult(this.content, this.filePath);
}