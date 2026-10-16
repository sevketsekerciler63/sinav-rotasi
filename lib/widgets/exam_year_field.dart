import 'package:flutter/material.dart';

class ExamYearField extends StatelessWidget {
  final int? value;
  final ValueChanged<int?> onChanged;
  const ExamYearField({
    super.key,
    required this.value,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().year;
    final years = {for (var y = now - 1; y <= now + 5; y++) y, ?value}.toList()
      ..sort();
    return DropdownButtonFormField<int>(
      initialValue: value ?? 0,
      decoration: const InputDecoration(
        labelText: 'Sınav yılı (isteğe bağlı)',
        helperText: 'Kişisel hedef tarihinden bağımsızdır.',
      ),
      items: [
        const DropdownMenuItem(value: 0, child: Text('Belirtilmedi')),
        ...years.map(
          (year) => DropdownMenuItem(value: year, child: Text('$year')),
        ),
      ],
      onChanged: (year) => onChanged(year == 0 ? null : year),
    );
  }
}
