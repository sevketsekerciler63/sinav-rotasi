import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/mock_exam.dart';
import '../models/net_score.dart';
import '../models/subject.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class MockExamScreen extends StatefulWidget {
  const MockExamScreen({super.key});

  @override
  State<MockExamScreen> createState() => _MockExamScreenState();
}

class _MockExamScreenState extends State<MockExamScreen> {
  final _sliderValues = <String, Map<String, double>>{};
  final _netControllers = <String, TextEditingController>{};
  final _netErrors = <String, String>{};
  final _attemptDates = <String, DateTime>{};
  final _explicitAttemptDates = <String>{};

  String _netFieldKey(String sliderKey, String subject) =>
      '$sliderKey::$subject';

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final completedExams =
            state.mockExams.where((e) => e.isCompleted).toList()..sort((
              first,
              second,
            ) {
              final dateOrder = first.displayDate.compareTo(second.displayDate);
              return dateOrder != 0 ? dateOrder : first.id.compareTo(second.id);
            });
        final examsWithAttemptDate = completedExams
            .where((exam) => exam.completedAt != null)
            .toList();
        final officialTytSubjects = state.tytSubjects
            .where((subject) => !subject.isCustom)
            .toList();
        final officialAytSubjects = state.aytSubjects
            .where((subject) => !subject.isCustom)
            .toList();
        final tytTrendCount = examsWithAttemptDate
            .where((exam) => exam.hasScoresForSubjects(officialTytSubjects))
            .length;
        final aytTrendCount = examsWithAttemptDate
            .where(
              (exam) =>
                  exam.type.contains('AYT') &&
                  exam.hasScoresForSubjects(officialAytSubjects),
            )
            .length;

        return Scaffold(
          appBar: AppBar(title: const Text('Deneme Takip')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (tytTrendCount >= 2 || aytTrendCount >= 2) ...[
                  Text(
                    'Net Trendi',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  _buildTrendChart(
                    examsWithAttemptDate,
                    officialTytSubjects,
                    officialAytSubjects,
                  ),
                  const SizedBox(height: 24),
                ],
                if (completedExams.isNotEmpty) ...[
                  _buildSummaryRow(completedExams, officialTytSubjects),
                  const SizedBox(height: 20),
                ],
                Text(
                  'Denemeler',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                ...state.mockExams.map(
                  (exam) => _buildExamCard(context, state, exam),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrendChart(
    List<MockExam> completedExams,
    List<Subject> officialTytSubjects,
    List<Subject> officialAytSubjects,
  ) {
    final tytSpots = <FlSpot>[];
    final aytSpots = <FlSpot>[];

    for (int i = 0; i < completedExams.length; i++) {
      if (completedExams[i].hasScoresForSubjects(officialTytSubjects)) {
        tytSpots.add(
          FlSpot(
            i.toDouble(),
            completedExams[i].totalForSubjects(officialTytSubjects),
          ),
        );
      }
      if (completedExams[i].type.contains('AYT') &&
          completedExams[i].hasScoresForSubjects(officialAytSubjects)) {
        aytSpots.add(
          FlSpot(
            i.toDouble(),
            completedExams[i].totalForSubjects(officialAytSubjects),
          ),
        );
      }
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 10,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: AppTheme.borderDark, strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 10,
                reservedSize: 30,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) => Text(
                  'D${value.toInt() + 1}',
                  style: const TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: tytSpots,
              isCurved: true,
              color: AppTheme.accentBlue,
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) =>
                    FlDotCirclePainter(
                      radius: 4,
                      color: AppTheme.accentBlue,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.accentBlue.withValues(alpha: 0.1),
              ),
            ),
            if (aytSpots.isNotEmpty)
              LineChartBarData(
                spots: aytSpots,
                isCurved: true,
                color: AppTheme.accentPurple,
                barWidth: 3,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, bar, index) =>
                      FlDotCirclePainter(
                        radius: 4,
                        color: AppTheme.accentPurple,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppTheme.accentPurple.withValues(alpha: 0.1),
                ),
              ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots
                  .map(
                    (s) => LineTooltipItem(
                      '${NetScore.format(s.y)} net',
                      TextStyle(
                        color: s.bar.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    List<MockExam> completedExams,
    List<Subject> officialTytSubjects,
  ) {
    final tytExams = completedExams
        .where(
          (exam) =>
              exam.completedAt != null &&
              exam.hasScoresForSubjects(officialTytSubjects),
        )
        .toList();
    final hasTyt = tytExams.isNotEmpty;
    final hasProgress = tytExams.length >= 2;
    final lastTyt = hasTyt
        ? tytExams.last.totalForSubjects(officialTytSubjects)
        : null;
    final tytGain = hasProgress
        ? tytExams.last.totalForSubjects(officialTytSubjects) -
              tytExams.first.totalForSubjects(officialTytSubjects)
        : null;

    return Row(
      children: [
        _summaryCard(
          'Son TYT',
          lastTyt == null ? '—' : NetScore.format(lastTyt),
          hasTyt ? AppTheme.accentBlue : Colors.white38,
        ),
        const SizedBox(width: 10),
        _summaryCard(
          'Ilerleme',
          tytGain == null
              ? '—'
              : '${tytGain >= 0 ? "+" : ""}${NetScore.format(tytGain)}',
          tytGain == null
              ? Colors.white38
              : tytGain >= 0
              ? AppTheme.accentGreen
              : AppTheme.accentRed,
        ),
        const SizedBox(width: 10),
        _summaryCard(
          'Deneme',
          '${completedExams.length}',
          AppTheme.accentOrange,
        ),
      ],
    );
  }

  Widget _summaryCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.borderDark),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamCard(BuildContext context, AppState state, MockExam exam) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scheduledDate = DateTime(
      exam.date.year,
      exam.date.month,
      exam.date.day,
    );
    final isPast = scheduledDate.isBefore(today);
    final isToday = scheduledDate == today;
    final tytSubjects = state.tytSubjects;
    final aytSubjects = state.aytSubjects;
    final officialTytSubjects = tytSubjects
        .where((subject) => !subject.isCustom)
        .toList();
    final officialAytSubjects = aytSubjects
        .where((subject) => !subject.isCustom)
        .toList();
    final extraTytSubjects = tytSubjects
        .where((subject) => subject.isCustom)
        .toList();
    final extraAytSubjects = aytSubjects
        .where((subject) => subject.isCustom)
        .toList();
    final trackedExtraAytSubjects = exam.type.contains('AYT')
        ? extraAytSubjects
        : <Subject>[];
    final examSubjects = [
      ...tytSubjects,
      if (exam.type.contains('AYT')) ...aytSubjects,
    ];
    final tytKeys = officialTytSubjects
        .map((subject) => MockExam.netKeyForSubject(subject.type, subject.name))
        .toList();
    final aytKeys = officialAytSubjects
        .map((subject) => MockExam.netKeyForSubject(subject.type, subject.name))
        .toList();
    final extraKeys = [...extraTytSubjects, ...trackedExtraAytSubjects]
        .map((subject) => MockExam.netKeyForSubject(subject.type, subject.name))
        .toList();
    final sliderKey = '${state.activeProfile.id}:${exam.id}';
    final attemptDate = _attemptDates.putIfAbsent(sliderKey, () {
      final defaultDate =
          exam.completedAt ?? (exam.isCompleted ? exam.date : now);
      return DateTime(defaultDate.year, defaultDate.month, defaultDate.day);
    });

    // Init slider values from exam
    _sliderValues.putIfAbsent(sliderKey, () {
      final m = exam.normalizedNets;
      for (final subject in examSubjects) {
        final key = MockExam.netKeyForSubject(subject.type, subject.name);
        m.putIfAbsent(
          key,
          () => exam.netForSubject(subject.type, subject.name),
        );
      }
      return m;
    });

    // Keep newly added profile subjects available when the screen is already open.
    final examValues = _sliderValues[sliderKey]!;
    for (final subject in examSubjects) {
      final key = MockExam.netKeyForSubject(subject.type, subject.name);
      examValues.putIfAbsent(
        key,
        () => exam.netForSubject(subject.type, subject.name),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: exam.isCompleted
            ? AppTheme.accentGreen.withValues(alpha: 0.06)
            : AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: exam.isCompleted
              ? AppTheme.accentGreen.withValues(alpha: 0.3)
              : AppTheme.borderDark,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.type,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Planlanan: ${_formatDate(exam.date)} · ${exam.dayName}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                    if (exam.isCompleted)
                      Text(
                        exam.completedAt == null
                            ? 'Gerçekleşme tarihi kayıtta yok'
                            : 'Gerçekleşti: ${_formatDate(exam.completedAt!)}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                    if (exam.updatedAt != null)
                      Text(
                        'Son düzenleme: ${_formatDate(exam.updatedAt!)}',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
              ),
              if (exam.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppTheme.successGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    exam.hasScoresForSubjects(officialTytSubjects)
                        ? 'TYT: ${NetScore.format(exam.totalForSubjects(officialTytSubjects))}'
                        : 'TYT: —',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (exam.isCompleted &&
              (exam.hasScoresForSubjects(extraTytSubjects) ||
                  exam.hasScoresForSubjects(trackedExtraAytSubjects)))
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Kişisel ek ders neti: '
                '${exam.hasScoresForSubjects(extraTytSubjects) ? 'TYT ${NetScore.format(exam.totalForSubjects(extraTytSubjects))}' : ''}'
                '${exam.hasScoresForSubjects(extraTytSubjects) && exam.hasScoresForSubjects(trackedExtraAytSubjects) ? ' · ' : ''}'
                '${exam.hasScoresForSubjects(trackedExtraAytSubjects) ? 'AYT ${NetScore.format(exam.totalForSubjects(trackedExtraAytSubjects))}' : ''} '
                '(resmî toplam dışında)',
                style: const TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ),
          Text(
            'Hedef: ${exam.targetNet}',
            style: TextStyle(color: AppTheme.accentOrange, fontSize: 12),
          ),

          if (isPast || isToday || exam.isCompleted) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    exam.isCompleted &&
                            exam.completedAt == null &&
                            !_explicitAttemptDates.contains(sliderKey)
                        ? 'Gerçekleşme tarihi belirtilmemiş'
                        : 'Sonuç tarihi: ${_formatDate(attemptDate)}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _chooseAttemptDate(
                    context,
                    sliderKey,
                    attemptDate,
                    today,
                  ),
                  icon: const Icon(Icons.event_outlined, size: 16),
                  label: const Text('Tarihi seç'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (officialTytSubjects.isNotEmpty) ...[
              const Text(
                'TYT Netleri · resmî dersler:',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
            ],
            ...officialTytSubjects.map(
              (subject) => _netSlider(
                sliderKey,
                MockExam.netKeyForSubject(subject.type, subject.name),
                subject.totalQuestions,
              ),
            ),
            if (extraTytSubjects.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Kişisel TYT ek dersleri · resmî toplam dışında:',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...extraTytSubjects.map(
                (subject) => _netSlider(
                  sliderKey,
                  MockExam.netKeyForSubject(subject.type, subject.name),
                  subject.totalQuestions,
                ),
              ),
            ],
            if (exam.type.contains('AYT')) ...[
              const SizedBox(height: 12),
              if (officialAytSubjects.isNotEmpty) ...[
                const Text(
                  'AYT Netleri · resmî dersler:',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              ...officialAytSubjects.map(
                (subject) => _netSlider(
                  sliderKey,
                  MockExam.netKeyForSubject(subject.type, subject.name),
                  subject.totalQuestions,
                ),
              ),
              if (extraAytSubjects.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text(
                  'Kişisel AYT ek dersleri · resmî toplam dışında:',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...extraAytSubjects.map(
                  (subject) => _netSlider(
                    sliderKey,
                    MockExam.netKeyForSubject(subject.type, subject.name),
                    subject.totalQuestions,
                  ),
                ),
              ],
            ],
            const SizedBox(height: 16),

            // Total display
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.cardDarkAlt,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _totalBadge(
                    'TYT',
                    tytKeys.fold(
                      0.0,
                      (s, k) => s + (_sliderValues[sliderKey]?[k] ?? 0),
                    ),
                    AppTheme.accentBlue,
                  ),
                  if (exam.type.contains('AYT'))
                    _totalBadge(
                      'AYT',
                      aytKeys.fold(
                        0.0,
                        (s, k) => s + (_sliderValues[sliderKey]?[k] ?? 0),
                      ),
                      AppTheme.accentPurple,
                    ),
                ],
              ),
            ),
            if (extraKeys.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Kişisel ek dersler (resmî toplama dahil değil): '
                '${NetScore.format(extraKeys.fold(0.0, (sum, key) => sum + (_sliderValues[sliderKey]?[key] ?? 0)))} net',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final validationErrors = <String, String>{};
                  for (final subject in examSubjects) {
                    final key = MockExam.netKeyForSubject(
                      subject.type,
                      subject.name,
                    );
                    final fieldKey = _netFieldKey(sliderKey, key);
                    final rawValue =
                        _netControllers[fieldKey]?.text ??
                        NetScore.format(_sliderValues[sliderKey]?[key] ?? 0);
                    final error = NetScore.validationError(
                      NetScore.parse(rawValue),
                      subject.totalQuestions,
                    );
                    if (error != null) validationErrors[fieldKey] = error;
                  }
                  if (validationErrors.isNotEmpty) {
                    setState(() {
                      _netErrors
                        ..clear()
                        ..addAll(validationErrors);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Netleri soru sayılarına göre düzelt.'),
                      ),
                    );
                    return;
                  }
                  final nets = exam.normalizedNets;
                  for (final subject in examSubjects) {
                    final key = MockExam.netKeyForSubject(
                      subject.type,
                      subject.name,
                    );
                    nets[key] = _sliderValues[sliderKey]?[key] ?? 0;
                  }
                  final selectedDateIsKnown =
                      !exam.isCompleted ||
                      exam.completedAt != null ||
                      _explicitAttemptDates.contains(sliderKey);
                  final updated = state.updateMockExam(
                    exam.id,
                    nets: nets,
                    isCompleted: true,
                    completedAt: selectedDateIsKnown ? attemptDate : null,
                  );
                  if (!updated && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Netler kaydedilemedi; değer aralığını denetle.',
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: exam.isCompleted
                      ? AppTheme.accentGreen
                      : AppTheme.accentBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  exam.isCompleted ? 'Guncellendi' : 'Netleri Kaydet',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _chooseAttemptDate(
    BuildContext context,
    String sliderKey,
    DateTime initialDate,
    DateTime today,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(today) ? today : initialDate,
      firstDate: DateTime(2000),
      lastDate: today,
      helpText: 'Denemenin gerçekleştiği günü seç',
      cancelText: 'Vazgeç',
      confirmText: 'Seç',
    );
    if (picked == null || !mounted) return;
    setState(() {
      _attemptDates[sliderKey] = DateTime(
        picked.year,
        picked.month,
        picked.day,
      );
      _explicitAttemptDates.add(sliderKey);
    });
  }

  String _formatDate(DateTime date) =>
      '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';

  Widget _netSlider(String sliderKey, String subject, int questionCount) {
    final shortName = subject.replaceFirst(RegExp(r'^(TYT|AYT) '), '');
    final val = _sliderValues[sliderKey]?[subject] ?? 0;
    final safeQuestionCount = questionCount < 0 ? 0 : questionCount;
    final minimum = NetScore.minimumForQuestionCount(safeQuestionCount);
    final max = safeQuestionCount > 0 ? safeQuestionCount.toDouble() : 1.0;
    final value = val.clamp(minimum, max).toDouble();
    final fieldKey = _netFieldKey(sliderKey, subject);
    final controller = _netControllers.putIfAbsent(
      fieldKey,
      () => TextEditingController(text: NetScore.format(val)),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              shortName,
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                activeTrackColor: AppTheme.accentBlue,
                inactiveTrackColor: AppTheme.borderDark,
                thumbColor: AppTheme.accentBlue,
              ),
              child: Slider(
                value: value,
                min: minimum,
                max: max,
                divisions: safeQuestionCount > 0 ? safeQuestionCount * 5 : 4,
                onChanged: safeQuestionCount == 0
                    ? null
                    : (v) {
                        final nextValue = (v * 4).round() / 4.0;
                        setState(() {
                          _sliderValues[sliderKey]?[subject] = nextValue;
                          _netErrors.remove(fieldKey);
                          final text = NetScore.format(nextValue);
                          controller.value = TextEditingValue(
                            text: text,
                            selection: TextSelection.collapsed(
                              offset: text.length,
                            ),
                          );
                        });
                      },
              ),
            ),
          ),
          SizedBox(
            width: 78,
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: val == 0 ? Colors.white54 : AppTheme.accentBlue,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Net',
                errorText: _netErrors[fieldKey],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 8,
                ),
              ),
              onChanged: (rawValue) {
                final parsed = NetScore.parse(rawValue);
                final error = NetScore.validationError(
                  parsed,
                  safeQuestionCount,
                );
                setState(() {
                  if (error == null && parsed != null) {
                    _sliderValues[sliderKey]?[subject] = parsed;
                    _netErrors.remove(fieldKey);
                  } else {
                    _netErrors[fieldKey] = error!;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalBadge(String label, double total, Color color) {
    return Column(
      children: [
        Text(
          NetScore.format(total),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        Text(
          '$label Toplam',
          style: const TextStyle(color: Colors.white38, fontSize: 10),
        ),
      ],
    );
  }

  @override
  void dispose() {
    for (final controller in _netControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
