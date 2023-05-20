import 'package:flutter/material.dart';
import 'package:ml_analytics/pages/common/go_to_forward_step.dart';
import 'package:ml_analytics/pages/param_output_page.dart';

class ParamInputPage extends StatefulWidget {
  const ParamInputPage({Key? key, required this.previewData}) : super(key: key);

  final List<List<dynamic>> previewData;

  @override
  State<ParamInputPage> createState() => _ParamInputPageState();
}

class _ParamInputPageState extends State<ParamInputPage> {
  List<int> selectedColumns = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione as colunas de entrada'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(border: Border.all()),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: List<DataColumn>.generate(
                      widget.previewData[0].length,
                      (colIndex) => const DataColumn(label: Offstage()),
                    ),
                    rows: widget.previewData
                        .take(25)
                        .map<DataRow>(
                          (row) => DataRow(
                            cells: row
                                .asMap()
                                .map(
                                  (i, cell) => MapEntry(
                                    i,
                                    DataCell(
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (selectedColumns.contains(i)) {
                                              selectedColumns.remove(i);
                                            } else {
                                              selectedColumns.add(i);
                                            }
                                          });
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          color: selectedColumns.contains(i)
                                              ? Colors.blue
                                              : null,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              cell.toString(),
                                              style: TextStyle(
                                                color:
                                                    selectedColumns.contains(i)
                                                        ? Colors.white
                                                        : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .values
                                .toList(),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: selectedColumns.isEmpty
                  ? null
                  : () {
                      selectedColumns.sort();
                      goToForwardStep(
                        context,
                        ParamOutputPage(
                          previewData: widget.previewData,
                          paramsInputList: selectedColumns,
                        ),
                      );
                    },
              child: const Text('Avançar'),
            ),
          ),
        ],
      ),
    );
  }
}
