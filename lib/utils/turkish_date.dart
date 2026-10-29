import '../models/daily_log.dart' show turkishWeekdayName;

const turkishMonthNames = [
  'Ocak',
  'Şubat',
  'Mart',
  'Nisan',
  'Mayıs',
  'Haziran',
  'Temmuz',
  'Ağustos',
  'Eylül',
  'Ekim',
  'Kasım',
  'Aralık',
];

/// "21 Ekim 2026", isteğe bağlı olarak "21 Ekim 2026 Çarşamba".
String turkishDate(
  DateTime date, {
  bool withYear = true,
  bool withWeekday = false,
}) {
  final buffer = StringBuffer(
    '${date.day} ${turkishMonthNames[date.month - 1]}',
  );
  if (withYear) buffer.write(' ${date.year}');
  if (withWeekday) buffer.write(' ${turkishWeekdayName(date)}');
  return buffer.toString();
}

/// Kayıtlarda tutulan "YYYY-AA-GG" gününü okur; geçersizse null döner.
DateTime? parseIsoDay(String? value) {
  if (value == null || !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
    return null;
  }
  final parsed = DateTime.tryParse(value);
  if (parsed == null || isoDay(parsed) != value) return null;
  return DateTime(parsed.year, parsed.month, parsed.day);
}

/// Saklama biçimi değişmez: "YYYY-AA-GG".
String isoDay(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

/// Kayıttaki günü Türkçe gösterir; okunamazsa kaydı olduğu gibi gösterir.
String turkishDayKey(
  String value, {
  bool withYear = true,
  bool withWeekday = false,
}) {
  final date = parseIsoDay(value);
  return date == null
      ? value
      : turkishDate(date, withYear: withYear, withWeekday: withWeekday);
}
