import 'package:flutter/material.dart';

class BodyBackgroundColor extends StatelessWidget {
  final Widget child;
  const BodyBackgroundColor({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF42A5F5), // Light Blue (darker)
            Color(0xFF0D47A1), // Darker Blue
          ],
        ),
      ),
      child: child,
    );
  }
}
