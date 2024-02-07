import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 128.0),
          child: LinearProgressIndicator(),
        ),
        SizedBox(height: 16),
        Text('Chargement...')
      ],
    );
  }
}
