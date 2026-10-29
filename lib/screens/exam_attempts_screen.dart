import '../theme/app_motion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exam_attempt.dart';
import '../models/net_score.dart';
import '../utils/turkish_date.dart';
import '../widgets/date_picker_field.dart';
import '../providers/app_state.dart';
import 'mock_exam_screen.dart';

String _label(ExamAttempt attempt) =>
    '${attempt.session}${attempt.area.isEmpty ? '' : ' · ${attempt.area.toUpperCase()}'}${attempt.language.isEmpty ? '' : ' · ${attempt.language}'}${attempt.religionExempt ? ' · Muaf' : ''}';

class ExamAttemptsScreen extends StatefulWidget {
  final bool comparisonOnly;
  const ExamAttemptsScreen({super.key, this.comparisonOnly = false});
  @override
  State<ExamAttemptsScreen> createState() => _ExamAttemptsScreenState();
}

class _ExamAttemptsScreenState extends State<ExamAttemptsScreen> {
  String session = 'Tümü';
  bool archived = false, busy = false;
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final attempts =
        state.examAttemptBook.attempts
            .where(
              (attempt) =>
                  attempt.archived == archived &&
                  (session == 'Tümü' || attempt.session == session),
            )
            .toList()
          ..sort((a, b) {
            final date = b.date.compareTo(a.date);
            return date == 0 ? b.id.compareTo(a.id) : date;
          });
    final groups = <String, List<ExamAttempt>>{};
    for (final attempt in attempts) {
      groups.putIfAbsent(attempt.comparisonKey, () => []).add(attempt);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.comparisonOnly ? 'Deneme karşılaştırma' : 'Denemelerim',
        ),
        actions: [
          IconButton(
            tooltip: 'Eski takvim kayıtları',
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              AppPageRoute(
                builder: (_) => const MockExamScreen(showLegacy: true),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: state.isProfileTransitioning
            ? null
            : () => Navigator.push(
                context,
                AppPageRoute(builder: (_) => const ExamAttemptEditor()),
              ),
        icon: const Icon(Icons.add),
        label: const Text('Deneme ekle'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          const Text(
            'Çözdüğün denemeleri kaydet. TYT, AYT ve YDT ayrı tutulur. Burada soru veya deneme kitapçığı sunulmaz.',
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: session,
            decoration: const InputDecoration(labelText: 'Oturum filtresi'),
            items: [
              for (final value in ['Tümü', 'TYT', 'AYT', 'YDT'])
                DropdownMenuItem(value: value, child: Text(value)),
            ],
            onChanged: (value) => setState(() => session = value!),
          ),
          SwitchListTile(
            title: const Text('Arşivdekileri göster'),
            value: archived,
            onChanged: (value) => setState(() => archived = value),
          ),
          if (!archived)
            for (final group in groups.values.where(
              (group) => group.length >= 2,
            ))
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_label(group.first)} · son iki sonuç',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${turkishDayKey(group[1].date)}: ${NetScore.format(group[1].totalNet)} → ${turkishDayKey(group[0].date)}: ${NetScore.format(group[0].totalNet)} net',
                      ),
                      Text(
                        'Fark: ${NetScore.format((group[0].totalNet - group[1].totalNet))} net. Yayınevi ve zorluk farkı sonucu etkileyebilir.',
                      ),
                      for (final test in YksAttemptCatalog.tests(
                        group.first.session,
                        group.first.area,
                        religionExempt: group.first.religionExempt,
                      ))
                        Text(
                          '${test.label}: ${NetScore.format(group[1].scores[test.id]!.net)} → ${NetScore.format(group[0].scores[test.id]!.net)}',
                        ),
                    ],
                  ),
                ),
              ),
          if (attempts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Henüz bu filtrede deneme yok. Çözdüğün ilk denemeyi ekle.',
              ),
            ),
          for (final attempt in attempts)
            Card(
              child: ExpansionTile(
                key: ValueKey(attempt.id),
                title: Text(attempt.title),
                subtitle: Text(
                  '${turkishDayKey(attempt.date)} · ${_label(attempt)} · ${NetScore.format(attempt.totalNet)} net',
                ),
                children: [
                  if (attempt.publisher.isNotEmpty)
                    ListTile(title: Text(attempt.publisher)),
                  for (final test in YksAttemptCatalog.tests(
                    attempt.session,
                    attempt.area,
                    religionExempt: attempt.religionExempt,
                  ))
                    ListTile(
                      title: Text(test.label),
                      subtitle: Text(
                        '${NetScore.format(attempt.scores[test.id]!.net)} / ${test.questions} net${attempt.scores[test.id]!.correct == null ? '' : ' · D: ${attempt.scores[test.id]!.correct}, Y: ${attempt.scores[test.id]!.wrong}, B: ${attempt.scores[test.id]!.blank}'}',
                      ),
                    ),
                  Wrap(
                    spacing: 8,
                    children: [
                      TextButton(
                        onPressed: busy || state.isProfileTransitioning
                            ? null
                            : () => Navigator.push(
                                context,
                                AppPageRoute(
                                  builder: (_) =>
                                      ExamAttemptEditor(attempt: attempt),
                                ),
                              ),
                        child: const Text('Düzenle'),
                      ),
                      TextButton(
                        onPressed: busy || state.isProfileTransitioning
                            ? null
                            : () async {
                                final profile = state.activeProfile.id;
                                setState(() => busy = true);
                                final ok = await state.archiveExamAttempt(
                                  attempt.id,
                                  !attempt.archived,
                                );
                                if (!context.mounted) return;
                                setState(() => busy = false);
                                if (!ok && state.activeProfile.id == profile) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        state.examAttemptError ??
                                            'Kayıt yapılamadı.',
                                      ),
                                    ),
                                  );
                                }
                              },
                        child: Text(
                          attempt.archived ? 'Arşivden çıkar' : 'Arşivle',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ExamAttemptEditor extends StatefulWidget {
  final ExamAttempt? attempt;
  const ExamAttemptEditor({super.key, this.attempt});
  @override
  State<ExamAttemptEditor> createState() => _ExamAttemptEditorState();
}

/// Deneme ileri tarihe yazılmaz; eski bir kayıttaki ileri tarih ise
/// düzenlenirken seçilebilir kalır.
DateTime _latestAttemptDate(String existing) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final current = parseIsoDay(existing);
  return current != null && current.isAfter(today) ? current : today;
}

class _ExamAttemptEditorState extends State<ExamAttemptEditor> {
  final title = TextEditingController(),
      publisher = TextEditingController(),
      date = TextEditingController();
  final fields = <String, TextEditingController>{};
  late String profile, id, session, area, language;
  bool counts = false, exempt = false, busy = false;
  String? error;
  @override
  void initState() {
    super.initState();
    final attempt = widget.attempt;
    profile = context.read<AppState>().activeProfile.id;
    id = attempt?.id ?? 'attempt-${DateTime.now().microsecondsSinceEpoch}';
    session = attempt?.session ?? 'TYT';
    area = attempt?.area.isNotEmpty == true ? attempt!.area : 'say';
    language = attempt?.language.isNotEmpty == true
        ? attempt!.language
        : 'İngilizce';
    title.text = attempt?.title ?? '';
    publisher.text = attempt?.publisher ?? '';
    date.text =
        attempt?.date ?? DateTime.now().toIso8601String().substring(0, 10);
    exempt = attempt?.religionExempt ?? false;
    counts =
        attempt != null &&
        attempt.scores.values.every((score) => score.correct != null);
    final specs = [
      ...YksAttemptCatalog.tyt,
      ...YksAttemptCatalog.tests('AYT', 'say'),
      ...YksAttemptCatalog.tests('AYT', 'ea'),
      ...YksAttemptCatalog.tests('AYT', 'soz'),
      ...YksAttemptCatalog.tests('YDT', ''),
    ];
    for (final spec in specs) {
      final score = attempt?.scores[spec.id];
      for (final kind in ['net', 'correct', 'wrong', 'blank']) {
        final key = '${spec.id}:$kind';
        fields.putIfAbsent(
          key,
          () => TextEditingController(
            text: switch (kind) {
              'net' => score?.net.toString() ?? '0',
              'correct' => score?.correct?.toString() ?? '0',
              'wrong' => score?.wrong?.toString() ?? '0',
              _ => score?.blank?.toString() ?? spec.questions.toString(),
            },
          ),
        );
      }
    }
    if (exempt && attempt != null) {
      fields['ayt_felsefe:blank']!.text =
          attempt.scores['ayt_felsefe']!.blank?.toString() ?? '18';
    }
  }

  @override
  void dispose() {
    for (final controller in [title, publisher, date, ...fields.values]) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget field(
    TextEditingController controller,
    String label, {
    bool numeric = false,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextField(
      controller: controller,
      enabled: !busy,
      keyboardType: numeric
          ? const TextInputType.numberWithOptions(decimal: true, signed: true)
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    ),
  );
  int integer(String key) {
    final number = int.tryParse(fields[key]!.text.trim());
    if (number == null) {
      throw const FormatException('Doğru, yanlış ve boş için tam sayı gir.');
    }
    return number;
  }

  Future<void> save() async {
    final state = context.read<AppState>();
    setState(() {
      busy = true;
      error = null;
    });
    try {
      if (state.activeProfile.id != profile || state.isProfileTransitioning) {
        throw const FormatException(
          'Profil değişti. Ekranı kapatıp yeniden aç.',
        );
      }
      final specs = YksAttemptCatalog.tests(
        session,
        area,
        religionExempt: exempt,
      );
      final scores = <String, AttemptScore>{};
      for (final spec in specs) {
        if (counts) {
          scores[spec.id] = AttemptScore.counts(
            integer('${spec.id}:correct'),
            integer('${spec.id}:wrong'),
            integer('${spec.id}:blank'),
          );
        } else {
          final value = double.tryParse(
            fields['${spec.id}:net']!.text.trim().replaceAll(',', '.'),
          );
          if (value == null) {
            throw FormatException('${spec.label} netini sayı olarak gir.');
          }
          scores[spec.id] = AttemptScore.net(value);
        }
      }
      final attempt = ExamAttempt(
        id: id,
        title: title.text.trim(),
        publisher: publisher.text.trim(),
        date: date.text.trim(),
        session: session,
        area: session == 'AYT' ? area : '',
        language: session == 'YDT' ? language : '',
        religionExempt: session == 'AYT' && area == 'soz' && exempt,
        archived: widget.attempt?.archived ?? false,
        scores: scores,
      );
      final ok = await state.saveExamAttempt(attempt);
      if (!mounted) return;
      if (ok) {
        Navigator.pop(context);
        return;
      }
      error = state.examAttemptError ?? 'Deneme kaydedilemedi. Yeniden dene.';
    } on FormatException catch (exception) {
      error = exception.message;
    } catch (_) {
      error = 'Deneme kaydedilemedi. Alanları kontrol edip yeniden dene.';
    }
    if (mounted) setState(() => busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final tests = YksAttemptCatalog.tests(
      session,
      area,
      religionExempt: exempt,
    );
    return PopScope(
      canPop: !busy,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.attempt == null ? 'Deneme ekle' : 'Denemeyi düzenle',
          ),
        ),
        body: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16),
          children: [
            field(title, 'Deneme adı'),
            field(publisher, 'Yayınevi (isteğe bağlı)'),
            DatePickerField(
              label: 'Çözdüğün gün',
              value: date.text.trim(),
              enabled: !busy,
              firstDate: DateTime(2000),
              lastDate: _latestAttemptDate(date.text.trim()),
              helpText: 'Denemeyi çözdüğün günü seç',
              onChanged: (value) {
                if (value != null) setState(() => date.text = value);
              },
            ),
            DropdownButtonFormField<String>(
              initialValue: session,
              decoration: const InputDecoration(labelText: 'Oturum'),
              items: [
                for (final value in ['TYT', 'AYT', 'YDT'])
                  DropdownMenuItem(value: value, child: Text(value)),
              ],
              onChanged: busy
                  ? null
                  : (value) => setState(() => session = value!),
            ),
            if (session == 'AYT')
              DropdownButtonFormField<String>(
                initialValue: area,
                decoration: const InputDecoration(labelText: 'Çözdüğün alan'),
                items: const [
                  DropdownMenuItem(value: 'say', child: Text('Sayısal')),
                  DropdownMenuItem(value: 'ea', child: Text('Eşit ağırlık')),
                  DropdownMenuItem(value: 'soz', child: Text('Sözel')),
                ],
                onChanged: busy
                    ? null
                    : (value) => setState(() => area = value!),
              ),
            if (session == 'YDT')
              DropdownButtonFormField<String>(
                initialValue: language,
                decoration: const InputDecoration(labelText: 'Dil'),
                items: [
                  for (final value in [
                    'İngilizce',
                    'Almanca',
                    'Arapça',
                    'Fransızca',
                    'Rusça',
                  ])
                    DropdownMenuItem(value: value, child: Text(value)),
                ],
                onChanged: busy
                    ? null
                    : (value) => setState(() => language = value!),
              ),
            if (session == 'AYT' && area == 'soz')
              SwitchListTile(
                title: const Text(
                  'Din kültüründen muafım; ilave felsefe çözdüm',
                ),
                value: exempt,
                onChanged: busy
                    ? null
                    : (value) => setState(() {
                        exempt = value;
                        if (widget.attempt == null) {
                          fields['ayt_felsefe:blank']!.text = value
                              ? '18'
                              : '12';
                        }
                      }),
              ),
            SwitchListTile(
              title: const Text('Doğru / yanlış / boş ile gir'),
              subtitle: const Text(
                'Kapalıyken doğrudan net girilir. 4 yanlış 1 doğruyu götürür.',
              ),
              value: counts,
              onChanged: busy
                  ? null
                  : (value) => setState(() => counts = value),
            ),
            for (final test in tests)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$session ${test.label} · ${test.questions} soru',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (!counts)
                        field(
                          fields['${test.id}:net']!,
                          '$session ${test.label} neti',
                          numeric: true,
                        )
                      else ...[
                        field(
                          fields['${test.id}:correct']!,
                          '${test.label} doğru',
                          numeric: true,
                        ),
                        field(
                          fields['${test.id}:wrong']!,
                          '${test.label} yanlış',
                          numeric: true,
                        ),
                        field(
                          fields['${test.id}:blank']!,
                          '${test.label} boş',
                          numeric: true,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            const Text(
              'Katalog: ÖSYM 2026. Bu sonuçlar puan veya sıralama tahmini değildir.',
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            FilledButton(
              onPressed: busy ? null : save,
              child: Text(busy ? 'Kaydediliyor…' : 'Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
