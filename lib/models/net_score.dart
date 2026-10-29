class NetScore {
  static const double _epsilon = 0.000001;

  static double minimumForQuestionCount(int questionCount) {
    if (questionCount <= 0) return 0;
    return -questionCount / 4;
  }

  static double? parse(String value) =>
      double.tryParse(value.trim().replaceAll(',', '.'));

  static String? validationError(double? value, int questionCount) {
    if (value == null || !value.isFinite) return 'Geçerli bir net gir.';
    if (questionCount < 0 ||
        value < minimumForQuestionCount(questionCount) - _epsilon ||
        value > questionCount + _epsilon) {
      return 'Net ${format(minimumForQuestionCount(questionCount))} ile '
          '$questionCount arasında olmalı.';
    }
    if ((value * 4 - (value * 4).round()).abs() > _epsilon) {
      return 'Net 0,25 adımlarla girilmeli.';
    }
    return null;
  }

  static bool isValid(double? value, int questionCount) =>
      validationError(value, questionCount) == null;

  static bool isStorable(double value) =>
      value.isFinite && value >= -50 && value <= 200;

  /// Türkçe ondalık gösterim: 25 → "25", 25.5 → "25,5", 59.75 → "59,75".
  /// Bütün net girişleri virgülü kabul ettiği için alanlara da yazılabilir.
  static String format(double value) {
    final quarterUnits = (value * 4).round();
    final String text;
    if ((value * 4 - quarterUnits).abs() <= _epsilon) {
      text = quarterUnits % 4 == 0
          ? (quarterUnits ~/ 4).toString()
          : (quarterUnits / 4).toString();
    } else {
      text = value.toStringAsFixed(2);
    }
    return text.replaceAll('.', ',');
  }
}
