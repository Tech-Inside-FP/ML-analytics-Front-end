// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({Key? key}) : super(key: key);

  @override
  UploadFileScreenState createState() => UploadFileScreenState();
}

class UploadFileScreenState extends State<UploadFileScreen> {
  String tableName = '';
  String maxCols = '0';
  String maxRows = '';

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

  bool loading = false;

  Future<void> _startIsolate(PlatformFile file) async {
    final receivePort = ReceivePort();
    final completer = Completer<void>();
    final isolate = await Isolate.spawn(
      processFileInBatches,
      {
        'sendPort': receivePort.sendPort,
        'file': file,
      },
      debugName: 'fileProcessingIsolate',
    );

    receivePort.listen((message) {
      if (message == 'done') {
        receivePort.close();
        isolate.kill(priority: Isolate.immediate);
        completer.complete();
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          tableName = message['tableName'];
          maxCols = message['maxCols'];
          maxRows = message['maxRows'];
          previewData = message['previewData'];
        });
      }
    });

    return completer.future;
  }

  Future<void> _selectFile() async {
    final pickedFiles = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'csv'],
      allowMultiple: false,
    );

    if (pickedFiles != null) {
      final file = pickedFiles.files.single;

      setState(() {
        loading = true;
      });

      await _startIsolate(file);
    }
  }

  List<List<dynamic>> previewData = [];

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
                  const SizedBox(height: 50),
                ],
              ),
            ),
            if (loading)
              const CircularProgressIndicator()
            else if (previewData.isNotEmpty &&
                isInt(maxCols) &&
                int.parse(maxCols) > 0)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: List<DataColumn>.generate(
                    int.parse(maxCols),
                    (colIndex) => const DataColumn(label: Text('')),
                  ),
                  rows: previewData
                      .map<DataRow>(
                        (row) => DataRow(
                          cells: row
                              .map<DataCell>(
                                  (cell) => DataCell(Text(cell.toString())))
                              .toList(),
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void processFileInBatches(Map<String, dynamic> args) async {
  final sendPort = args['sendPort'] as SendPort;
  final file = args['file'] as PlatformFile;
  String? extension = file.extension;
  Uint8List? bytes = file.bytes;
  String tableName = '';
  String maxCols = '0';
  String maxRows = '';
  List<List<dynamic>> previewData = [];

  if (bytes != null) {
    if (extension == 'xlsx') {
      var excelData = Excel.decodeBytes(bytes);
      for (var table in excelData.tables.keys) {
        tableName = table;
        maxCols = excelData.tables[table]!.maxCols.toString();
        maxRows = excelData.tables[table]!.maxRows.toString();

        int batchSize = 5;
        int numBatches =
            (excelData.tables[table]!.maxRows + batchSize - 1) ~/ batchSize;

        for (int i = 0; i < numBatches; i++) {
          int startRow = i * batchSize;
          int endRow = (i + 1) * batchSize;
          if (endRow > excelData.tables[table]!.maxRows) {
            endRow = excelData.tables[table]!.maxRows;
          }

          previewData.addAll(excelData.tables[table]!.rows
              .getRange(startRow, endRow)
              .map((row) =>
                  row.map((cell) => cell?.value?.toString() ?? '').toList())
              .toList());
        }
        break;
      }
    } else if (extension == 'csv') {
      String csvString;
      if (utf8.decoder.convert(bytes).isNotEmpty) {
        csvString = utf8.decoder.convert(bytes);
      } else {
        csvString = const Utf8Decoder(allowMalformed: true).convert(bytes);
      }

      List<List<dynamic>> csvData =
          const CsvToListConverter().convert(csvString);
      tableName = 'CSV';
      maxCols = csvData[0].length.toString();
      maxRows = csvData.length.toString();

      int batchSize = 5;
      int numBatches = (csvData.length + batchSize - 1) ~/ batchSize;

      for (int i = 0; i < numBatches; i++) {
        int startRow = i * batchSize;
        int endRow = (i + 1) * batchSize;
        if (endRow > csvData.length) {
          endRow = csvData.length;
        }

        previewData.addAll(csvData.getRange(startRow, endRow).toList());
      }
    } else {
      print('No valid extension or bytes is null.');
    }
  }

  sendPort.send({
    'tableName': tableName,
    'maxCols': maxCols,
    'maxRows': maxRows,
    'previewData': previewData,
  });

  sendPort.send('done');
}
