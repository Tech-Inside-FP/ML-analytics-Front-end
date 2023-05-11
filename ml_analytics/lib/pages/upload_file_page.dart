import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ml_analytics/pages/file_preview_page.dart';

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({Key? key}) : super(key: key);

  @override
  UploadFileScreenState createState() => UploadFileScreenState();
}

class UploadFileScreenState extends State<UploadFileScreen> {
  List<List<dynamic>> csvData = [];

  bool isUtf8(List<int> bytes) {
    try {
      utf8.decode(bytes);
      return true;
    } catch (_) {
      return false;
    }
  }

  bool isInt(String value) {
    return int.tryParse(value) != null;
  }

  Future<void> _processFile(PlatformFile file) async {
    String? extension = file.extension;
    Uint8List? bytes = file.bytes;

    if (bytes != null) {
      if (extension == 'csv') {
        String csvString;
        try {
          csvString = utf8.decoder.convert(bytes);
        } catch (_) {
          csvString = const Utf8Decoder(allowMalformed: true).convert(bytes);
        }

        csvData = const CsvToListConverter().convert(csvString);

        setState(() {
          previewData = csvData;
        });
      } else {
        debugPrint('No valid extension or bytes is null.');
      }
    }
  }

  Future<void> _selectFile() async {
    final pickedFiles = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      allowMultiple: false,
    );

    if (pickedFiles != null) {
      setState(() {
        isLoading = true;
      });
      final file = pickedFiles.files.single;
      await _processFile(file).then((value) async {
        await Future.delayed(const Duration(seconds: 2)).then((value) {
          Navigator.of(context)
              .push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return FilePreviewPage(previewData: previewData);
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = const Offset(1.0, 0.0);
                    var end = Offset.zero;
                    var curve = Curves.easeOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              )
              .then(
                (value) => setState(() {
                  isLoading = false;
                }),
              );
        });
      });
    }
  }

  List<List<dynamic>> previewData = [];

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload do arquivo'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Center(
                child: SizedBox(
                  height: 40,
                  // width: 120,
                  child: ElevatedButton(
                    onPressed: _selectFile,
                    child: const Text('Selecione um arquivo CSV'),
                  ),
                ),
              ),
      ),
    );
  }
}
