import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';

import 'package:ml_analytics/pages/common/go_to_forward_step.dart';
import 'package:ml_analytics/pages/model_view_and_download_page.dart';

class ProcessingModelPage extends StatefulWidget {
  const ProcessingModelPage({Key? key, required this.previewData})
      : super(key: key);

  final List<List<dynamic>> previewData;

  @override
  ProcessingModelPageState createState() => ProcessingModelPageState();
}

class ProcessingModelPageState extends State<ProcessingModelPage> {
  List<DataEntry> mockData = [];
  List<charts.Series<DataEntry, String>> chartSeries = [];
  List<charts.Series<DataEntry, String>>? pieChartSeries;
  List<String> insights = [];
  bool isModelGenerated = false;
  bool isButtonVisible = false;

  @override
  void initState() {
    super.initState();
    // Chamar a função de requisição dos dados da API
    // Aqui estou chamando a função após 5 segundos para simular o retorno dos dados
    Timer(const Duration(seconds: 2), () {
      // Simular os dados retornados pela API
      mockData = [
        DataEntry('Categoria 1', 20),
        DataEntry('Categoria 2', 35),
        DataEntry('Categoria 3', 15),
        DataEntry('Categoria 4', 25),
      ];

      chartSeries = [
        charts.Series<DataEntry, String>(
          id: 'Gráfico de Barras',
          data: mockData,
          domainFn: (DataEntry entry, _) => entry.category,
          measureFn: (DataEntry entry, _) => entry.value,
        ),
      ];

      pieChartSeries = [
        charts.Series<DataEntry, String>(
          id: 'Gráfico de Pizza',
          data: mockData,
          domainFn: (DataEntry entry, _) => entry.category,
          measureFn: (DataEntry entry, _) => entry.value,
          labelAccessorFn: (DataEntry entry, _) =>
              '${entry.category}: ${entry.value}',
        ),
      ];

      insights = [
        'Algumas informações e insights relevantes podem ser exibidos aqui com base nos dados recebidos da API.',
        'Por exemplo, o valor máximo encontrado foi ${mockData.map((entry) => entry.value).reduce((max, value) => value > max ? value : max)}.',
        'Outro insight interessante pode ser adicionado aqui.',
        'E mais um insight para completar a lista.',
      ];

      setState(() {
        isModelGenerated = true;
      });
      Future.delayed(const Duration(seconds: 4), () {
        setState(() {
          isButtonVisible = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 250,
                      child: Visibility(
                        visible: isModelGenerated,
                        child: charts.BarChart(
                          chartSeries,
                          animate: true,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      child: Visibility(
                        visible: isModelGenerated,
                        child: charts.PieChart(
                          chartSeries,
                          animate: true,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: insights.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 250,
                          child: ListTile(
                            title: Text(
                              insights[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!isButtonVisible) ...[
                      Text(
                        'Gerando o modelo...',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      const CircularProgressIndicator(),
                    ] else ...[
                      Column(
                        children: [
                          Text(
                            'Modelo gerado!',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () => goToForwardStep(
                                context,
                                const ModelViewAndDownloadPage(),
                              ),
                              child: const Text('Avançar para o modelo'),
                            ),
                          )
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Visibility(
                    visible: isModelGenerated,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(border: Border.all()),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: List<DataColumn>.generate(
                                  int.parse(
                                      widget.previewData[0].length.toString()),
                                  (colIndex) =>
                                      const DataColumn(label: Offstage()),
                                ),
                                rows: widget.previewData
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
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Baixar base tratada'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataEntry {
  final String category;
  final int value;

  DataEntry(this.category, this.value);
}
