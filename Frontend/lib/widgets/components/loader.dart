import 'package:flutter/material.dart';

import '../../classes/enums/breakpoints.dart';

class Loader extends StatelessWidget {
  const Loader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MediaQuery.of(context).size.width > Breakpoints.tablet.size
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 128.0),
                child: LinearProgressIndicator(),
              )
            : const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: CircularProgressIndicator(),
              ),
        const SizedBox(height: 16),
        const Text('Chargement...')
      ],
    );
  }
}
