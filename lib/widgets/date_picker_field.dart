import 'package:flutter/material.dart';

import '../utils/turkish_date.dart';

/// Tarihi elle "YYYY-AA-GG" yazdırmak yerine takvimden seçtirir.
/// Değer kayıtlarda yine "YYYY-AA-GG" olarak tutulur.
class DatePickerField extends StatelessWidget {
  final String label;
  final String? value;
  final bool enabled;
  final bool optional;
  final DateTime firstDate;
  final DateTime lastDate;
  final String helpText;
  final ValueChanged<String?> onChanged;

  const DatePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.helpText = 'Tarih seç',
    this.enabled = true,
    this.optional = false,
  });

  Future<void> _pick(BuildContext context) async {
    final current = parseIsoDay(value);
    final today = DateTime.now();
    var initial = current ?? DateTime(today.year, today.month, today.day);
    if (initial.isBefore(firstDate)) initial = firstDate;
    if (initial.isAfter(lastDate)) initial = lastDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: helpText,
      cancelText: 'Vazgeç',
      confirmText: 'Seç',
    );
    if (picked != null) onChanged(isoDay(picked));
  }

  @override
  Widget build(BuildContext context) {
    final date = parseIsoDay(value);
    final text = date == null
        ? (optional ? 'Seçilmedi' : 'Tarih seç')
        : turkishDate(date, withWeekday: true);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Semantics(
        button: true,
        label: '$label: $text. Takvimden seç',
        excludeSemantics: true,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: enabled ? () => _pick(context) : null,
          child: InputDecorator(
            isEmpty: false,
            decoration: InputDecoration(
              labelText: label,
              enabled: enabled,
              border: const OutlineInputBorder(),
              suffixIcon: optional && date != null && enabled
                  ? IconButton(
                      tooltip: 'Tarihi temizle',
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => onChanged(null),
                    )
                  : const Icon(Icons.calendar_today_outlined),
            ),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
