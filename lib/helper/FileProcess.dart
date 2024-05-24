
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:open_file/open_file.dart';

import 'package:path_provider/path_provider.dart';

class FileProcess {
  static bool isFolderCreated = false;
  static Directory? directory;

  static checkDocumentFolder() async {
    try {
      if (!isFolderCreated) {
        directory = await getApplicationDocumentsDirectory();
        await directory!.exists().then((value) {
          if (value) directory!.create();
          isFolderCreated = true;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<String> downloadFile(String st,String fn) async {
    final base64str = st;

    var bytes = base64Decode(base64str);
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/${fn}");
    await file.writeAsBytes(bytes.buffer.asUint8List());
    print("${output.path}/${fn}");
    await OpenFile.open("${output.path}/${fn}");
    return "dd";
  }

}