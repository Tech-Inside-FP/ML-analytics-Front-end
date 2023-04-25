// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({Key? key}) : super(key: key);

  @override
  UploadFileScreenState createState() => UploadFileScreenState();
}

class UploadFileScreenState extends State<UploadFileScreen> {
  String tableName = '';
  String maxCols = '';
  String maxRows = '';

  bool isUtf8(List<int> bytes) {
    try {
      utf8.decode(bytes);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _selectFile() async {
    final pickedFiles = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'csv'],
      allowMultiple: false,
    );

    if (pickedFiles != null) {
      final file = pickedFiles.files.single;

      String? extension = file.extension;
      Uint8List? bytes = file.bytes;

      if (bytes != null) {
        if (extension == 'xlsx') {
          var excel = Excel.decodeBytes(bytes);
          for (var table in excel.tables.keys) {
            setState(() {
              tableName = table;
              maxCols = excel.tables[table]!.maxCols.toString();
              maxRows = excel.tables[table]!.maxRows.toString();
            });
            break;
          }
        } else if (extension == 'csv') {
          String csvString;
          if (isUtf8(bytes)) {
            csvString = utf8.decode(bytes);
          } else {
            csvString = const Utf8Decoder(allowMalformed: true).convert(bytes);
          }

          List<List<dynamic>> csvData =
              const CsvToListConverter().convert(csvString);

          setState(() {
            tableName = 'CSV';
            maxCols = csvData[0].length.toString();
            maxRows = csvData.length.toString();
          });
        } else {
          print('No valid extension or bytes is null.');
        }
      }
    }
  }

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
              onPressed: _selectFile,
              child: const Text('Select XLSX or CSV File'),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: tableName.isNotEmpty,
              child: Column(
                children: [
                  Text('Nome da tabela: $tableName'),
                  const SizedBox(height: 5),
                  Text('Quantidade de colunas: $maxCols'),
                  const SizedBox(height: 5),
                  Text('Quantidade de linhas: $maxRows'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
