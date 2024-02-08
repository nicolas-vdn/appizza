import 'package:flutter/material.dart';

class CardGradient extends StatelessWidget {
  const CardGradient({super.key, required this.child, this.width, this.borderRadius});

  final Widget child;
  final double? width;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromARGB(255, 204, 0, 0),
            Color.fromARGB(255, 153, 0, 51),
          ],
        ),
        borderRadius: borderRadius,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 2.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: child,
    );
  }
}
