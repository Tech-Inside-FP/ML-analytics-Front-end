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
            SizedBox(
              height: 35,
              width: 120,
              child: ElevatedButton(
                onPressed: () => goToForwardStep(
                  context,
                  ParamInputPage(previewData: previewData),
                ),
                child: const Text('Regressão'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 35,
              width: 120,
              child: ElevatedButton(
                onPressed: () => goToForwardStep(
                  context,
                  ParamInputPage(previewData: previewData),
                ),
                child: const Text('Classificação'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
