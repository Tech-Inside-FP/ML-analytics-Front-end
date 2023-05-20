import 'package:flutter/material.dart';
import 'package:ml_analytics/pages/common/go_to_forward_step.dart';
import 'package:ml_analytics/pages/select_model_page.dart';

class FilePreviewPage extends StatelessWidget {
  const FilePreviewPage({Key? key, required this.previewData})
      : super(key: key);

  final String tableName = 'CSV';
  final List<List<dynamic>> previewData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pré visualização do arquivo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              const SizedBox(height: 35),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(border: Border.all()),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: List<DataColumn>.generate(
                        int.parse(previewData[0].length.toString()),
                        (colIndex) => const DataColumn(label: Text('')),
                      ),
                      rows: previewData
                          .take(25)
                          .map<DataRow>(
                            (row) => DataRow(
                              cells: row
                                  .map<DataCell>((cell) =>
                                      DataCell(Text(cell.toString())))
                                  .toList(),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 35,
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Voltar'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    height: 35,
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () => goToForwardStep(
                        context,
                        SelectModelPage(previewData: previewData),
                      ),
                      child: const Text('Avançar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
