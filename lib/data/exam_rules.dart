/// Verified against the 2026 ÖSYM YKS guide. Review when a new guide is issued.
/// These durations do not imply that a future exam date has been announced.
class YksExamRules {
  const YksExamRules._();

  static const referenceYear = 2026;
  static const sourceUrl =
      'https://dokuman.osym.gov.tr/pdfdokuman/2026/YKS/basvuru_kilavuz06022026.pdf';
  static const tytMinutes = 165;
  static const aytMinutes = 180;
  static const ydtMinutes = 120;
  // A study exercise, not the duration of an official AYT session.
  static const shortAytPracticeMinutes = 60;

  static const tytLabel = '$tytMinutes dk';
  static const aytLabel = '$aytMinutes dk';
  static const combinedLabel = '$tytMinutes+$aytMinutes dk';
  static const combinedTotalMinutes = tytMinutes + aytMinutes;
  static const tytAndShortAytLabel =
      '${tytMinutes + shortAytPracticeMinutes} dk';
}
