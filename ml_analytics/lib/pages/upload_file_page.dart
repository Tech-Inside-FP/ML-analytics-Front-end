import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadCsvScreen extends StatefulWidget {
  const UploadCsvScreen({super.key});

  @override
  UploadCsvScreenState createState() => UploadCsvScreenState();
}

class UploadCsvScreenState extends State<UploadCsvScreen> {
  String tableName = '';
  String maxCols = '';
  String maxRowls = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload File'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? pickedFile =
                    await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['xlsx'],
                  allowMultiple: false,
                );
                if (pickedFile != null) {
                  var bytes = pickedFile.files.single.bytes;
                  var excel = Excel.decodeBytes(bytes!);
                  for (var table in excel.tables.keys) {
                    setState(() {
                      tableName = table;
                      maxCols = excel.tables[table]!.maxCols.toString();
                      maxRowls = excel.tables[table]!.maxRows.toString();
                    });
                  }
                }
              },
              child: const Text('Select XLSX File'),
            ),
            const SizedBox(height: 20),
            // ignore: prefer_interpolation_to_compose_strings
            Text('Nome da tabela: ' + tableName),
            const SizedBox(height: 5),
            Text('Quantidade de colunas: $maxCols'),
            const SizedBox(height: 5),
            Text('Quantidade de linhas: $maxRowls'),
          ],
        ),
      ),
    );
  }
}
