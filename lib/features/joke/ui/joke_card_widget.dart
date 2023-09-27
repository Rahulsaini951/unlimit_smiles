import 'package:flutter/material.dart';

class JokeCard extends StatelessWidget {
  final String joke;

  const JokeCard({super.key, required this.joke});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Adjust the elevation as needed
      margin: const EdgeInsets.all(8), // Adjust margins as needed
      child: Padding(
        padding: const EdgeInsets.all(16), // Adjust padding as needed
        child: Text(
          joke,
          style: const TextStyle(fontSize: 16), // Adjust text style as needed
        ),
      ),
    );
  }
}
