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

  static String format(double value) {
    final quarterUnits = (value * 4).round();
    if ((value * 4 - quarterUnits).abs() <= _epsilon) {
      if (quarterUnits % 4 == 0) {
        return '${(quarterUnits / 4).toStringAsFixed(0)}.0';
      }
      return (quarterUnits / 4).toStringAsFixed(2);
    }
    return value.toStringAsFixed(2);
  }
}
