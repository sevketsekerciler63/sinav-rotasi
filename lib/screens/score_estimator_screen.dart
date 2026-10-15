import 'package:flutter/material.dart';

import 'score_calculator_screen.dart';

/// Compatibility entry point for older routes. Both score tools now use the
/// transparent, profile-aware net calculator instead of inventing a score.
class ScoreEstimatorScreen extends StatelessWidget {
  const ScoreEstimatorScreen({super.key});

  @override
  Widget build(BuildContext context) => const ScoreCalculatorScreen();
}
