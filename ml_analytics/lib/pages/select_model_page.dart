import 'package:flutter/material.dart';
import 'package:ml_analytics/pages/common/go_to_forward_step.dart';
import 'package:ml_analytics/pages/param_input_page.dart';

class SelectModelPage extends StatelessWidget {
  const SelectModelPage({super.key, required this.previewData});

  final List<List<dynamic>> previewData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione o tipo do modelo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ModelChoice(
              onPressed: () => goToForwardStep(
                context,
                ParamInputPage(previewData: previewData),
              ),
              label: 'Regressão',
              info:
                  'Regressão é um modelo matemático utilizado para entender a relação entre uma variável dependente\n(que queremos prever) e uma ou mais variáveis independentes (que usamos para fazer a previsão).',
            ),
            const SizedBox(height: 20),
            ModelChoice(
              onPressed: () => goToForwardStep(
                context,
                ParamInputPage(previewData: previewData),
              ),
              label: 'Classificação',
              info:
                  'Classificação é um tipo de aprendizado de máquina que tem como objetivo identificar a que categoria uma\nnova observação pertence, com base em um conjunto de treinamento de observações já categorizadas.',
            ),
          ],
        ),
      ),
    );
  }
}

class ModelChoice extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final String info;

  const ModelChoice({
    super.key,
    required this.onPressed,
    required this.label,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 45,
            width: 120,
            child: ElevatedButton(
              onPressed: onPressed,
              child: Text(label),
            ),
          ),
          const SizedBox(width: 10),
          Align(
            alignment: Alignment.topRight,
            child: Tooltip(
              message: info,
              textAlign: TextAlign.center,
              textStyle: const TextStyle(fontSize: 14, color: Colors.white),
              child: Container(
                height: 30,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.question_mark,
                    size: 17,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
