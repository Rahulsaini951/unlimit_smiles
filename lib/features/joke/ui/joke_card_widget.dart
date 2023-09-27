import 'package:flutter/material.dart';
import 'package:unlimit_smiles/utils/constants.dart';

class JokeCard extends StatelessWidget {
  final String joke;

  const JokeCard({super.key, required this.joke});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      surfaceTintColor: AppColors.primary,
      color: AppColors.black,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          joke,
          style: const TextStyle(fontSize: AppFontSizes.large, color: AppColors.primary),
        ),
      ),
    );
  }
}
