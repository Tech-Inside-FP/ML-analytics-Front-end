import 'package:flutter/material.dart';

class ParamOutputPage extends StatefulWidget {
  const ParamOutputPage({
    Key? key,
    required this.previewData,
    required this.paramsInputList,
  }) : super(key: key);

  final List<List<dynamic>> previewData;
  final List<int> paramsInputList;

  @override
  State<ParamOutputPage> createState() => _ParamOutputPageState();
}

class _ParamOutputPageState extends State<ParamOutputPage> {
  int? selectedColumn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione a coluna de saída'),
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
                                            selectedColumn = i;
                                          });
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          color: selectedColumn == i
                                              ? Colors.blue
                                              : null,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              cell.toString(),
                                              style: TextStyle(
                                                color: selectedColumn == i
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
              onPressed: selectedColumn == null
                  ? null
                  : () {
                      debugPrint('selected column: $selectedColumn');
                    },
              child: const Text('Avançar'),
            ),
          ),
        ],
      ),
    );
  }
}
