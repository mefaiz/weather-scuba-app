import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/providers/weather_controller.dart';

class UIInitial extends ConsumerWidget {
  const UIInitial({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () =>
            ref.read(weatherControllerProvider.notifier).fetchByCoordinates(),
        child: const Text(
          'Get Weather',
          style: TextStyle(color: Color(0xFF1E88E5)),
        ),
      ),
    );
  }
}
