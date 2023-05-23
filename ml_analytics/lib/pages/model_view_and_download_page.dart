import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class ModelViewAndDownloadPage extends StatefulWidget {
  const ModelViewAndDownloadPage({Key? key}) : super(key: key);

  @override
  ModelViewAndDownloadPageState createState() =>
      ModelViewAndDownloadPageState();
}

class ModelViewAndDownloadPageState extends State<ModelViewAndDownloadPage> {
  // Define os dados simulados
  final List<DataPoint> data = [
    DataPoint(x: 0, y: 0),
    DataPoint(x: 1, y: 1),
    DataPoint(x: 2, y: 2),
    DataPoint(x: 3, y: 3),
    DataPoint(x: 4, y: 4),
  ];

  // Define a linha de melhor ajuste (neste caso, y = x)
  final line = [
    DataPoint(x: 0, y: 0),
    DataPoint(x: 4, y: 4),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualização e download do modelo'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: const [
                ModelInfoTile(
                    info: 'MSE: 0.5',
                    tooltip:
                        'Erro Quadrático Médio: Medida da média dos quadrados dos erros.'),
                ModelInfoTile(
                    info: 'RMSE: 0.7',
                    tooltip:
                        'Raiz do Erro Quadrático Médio: A raiz quadrada da média do quadrado de todos os erros.'),
                ModelInfoTile(
                    info: 'R^2: 0.9',
                    tooltip:
                        'R quadrado: A proporção da variância para uma variável dependente que é explicada por uma variável independente.'),
                ModelInfoTile(
                    info: 'Coeficiente angular: 1',
                    tooltip:
                        'Coeficiente Angular: Representa a taxa de mudança de uma variável (Y) com base em mudanças na outra variável (X). É a mudança em Y para uma mudança unitária em X.'),
                ModelInfoTile(
                    info: 'Coeficiente linear: 0',
                    tooltip: 'Coeficiente Linear: A interseção Y da linha.'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: SizedBox(
                width: 500,
                height: 300,
                child: charts.ScatterPlotChart(
                  [
                    charts.Series<DataPoint, int>(
                      id: 'Data',
                      colorFn: (_, __) =>
                          charts.MaterialPalette.blue.shadeDefault,
                      domainFn: (DataPoint dp, _) => dp.x,
                      measureFn: (DataPoint dp, _) => dp.y,
                      data: data,
                    ),
                    charts.Series<DataPoint, int>(
                      id: 'Best Fit Line',
                      colorFn: (_, __) =>
                          charts.MaterialPalette.red.shadeDefault,
                      domainFn: (DataPoint dp, _) => dp.x,
                      measureFn: (DataPoint dp, _) => dp.y,
                      data: line,
                      strokeWidthPxFn: (_, __) => 3,
                    )..setAttribute(charts.rendererIdKey, 'customLine'),
                  ],
                  animate: true,
                  customSeriesRenderers: [
                    charts.LineRendererConfig(
                      customRendererId: 'customLine',
                    ),
                  ],
                ),
              ),
            ),
            const Text(
              'Este gráfico mostra um modelo de regressão linear simples. Os pontos azuis são dados\nobservados e a linha vermelha é a linha de melhor ajuste.',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Download do modelo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModelInfoTile extends StatelessWidget {
  final String info;
  final String tooltip;

  const ModelInfoTile({super.key, required this.info, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      textAlign: TextAlign.center,
      textStyle: const TextStyle(fontSize: 14, color: Colors.white),
      child: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 20,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(info),
                const SizedBox(width: 3),
                const Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.info_outline,
                    size: 15,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DataPoint {
  final int x;
  final int y;

  DataPoint({required this.x, required this.y});
}
