import 'package:flutter/material.dart';

class SelectModelPage extends StatelessWidget {
  const SelectModelPage({super.key});

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
                onPressed: () {},
                child: const Text('Regressão'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 35,
              width: 120,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Classificação'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
