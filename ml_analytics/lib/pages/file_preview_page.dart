import 'package:flutter/material.dart';
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
                child: Expanded(
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
                                    .map<DataCell>(
                                        (cell) => DataCell(Text(cell.toString())))
                                    .toList(),
                              ),
                            )
                            .toList(),
                      ),
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
                      onPressed: () => Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              const SelectModelPage(),
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
