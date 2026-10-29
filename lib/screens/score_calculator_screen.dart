import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/net_score.dart';
import '../models/subject.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class ScoreCalculatorScreen extends StatefulWidget {
  const ScoreCalculatorScreen({super.key});

  @override
  State<ScoreCalculatorScreen> createState() => _ScoreCalculatorScreenState();
}

class _ScoreCalculatorScreenState extends State<ScoreCalculatorScreen> {
  final Map<String, double> _nets = {};
  final Map<String, TextEditingController> _netControllers = {};
  final Map<String, String> _netErrors = {};
  String? _profileId;

  String _keyFor(Subject subject) => '${subject.type}_${subject.storageId}';

  double _netFor(Subject subject) =>
      _nets.putIfAbsent(_keyFor(subject), () => 0);

  double _totalFor(Iterable<Subject> subjects) =>
      subjects.fold(0, (total, subject) => total + _netFor(subject));

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final colors = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;
        if (_profileId != state.activeProfile.id) {
          _profileId = state.activeProfile.id;
          _nets.clear();
          _netErrors.clear();
          for (final controller in _netControllers.values) {
            controller.dispose();
          }
          _netControllers.clear();
        }

        final tytSubjects = state.visibleSubjects
            .where((subject) => subject.type == 'TYT')
            .toList();
        final aytSubjects = state.visibleSubjects
            .where((subject) => subject.type == 'AYT')
            .toList();
        final officialTyt = tytSubjects
            .where((subject) => !subject.isCustom)
            .toList();
        final officialAyt = aytSubjects
            .where((subject) => !subject.isCustom)
            .toList();
        final extraTyt = tytSubjects
            .where((subject) => subject.isCustom)
            .toList();
        final extraAyt = aytSubjects
            .where((subject) => subject.isCustom)
            .toList();
        final tytNet = _totalFor(officialTyt);
        final aytNet = _totalFor(officialAyt);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Deneme Neti Hesapla'),
            actions: [
              IconButton(
                tooltip: 'Netleri sıfırla',
                onPressed: _nets.isEmpty
                    ? null
                    : () {
                        setState(() {
                          _nets.clear();
                          _netErrors.clear();
                          for (final controller in _netControllers.values) {
                            controller.text = '0.0';
                          }
                        });
                      },
                icon: const Icon(Icons.restart_alt_rounded),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _summaryCard(
                tytNet,
                officialTyt,
                aytNet,
                officialAyt,
                extraTytNet: _totalFor(extraTyt),
                extraAytNet: _totalFor(extraAyt),
                hasExtraSubjects: extraTyt.isNotEmpty || extraAyt.isNotEmpty,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.tertiaryContainer.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: colors.tertiary.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  'Bu araç yalnızca girdiğin deneme netlerini toplar. Resmî puan ve başarı sırası; ilgili yılın kılavuzu ve değerlendirme verileriyle hesaplandığı için burada tahmin gösterilmez.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onTertiaryContainer,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ),
              if (officialTyt.isNotEmpty) ...[
                const SizedBox(height: 24),
                _subjectSection(
                  title: 'TYT · Resmî dersler',
                  subjects: officialTyt,
                  color: colors.secondary,
                ),
              ],
              if (officialAyt.isNotEmpty) ...[
                const SizedBox(height: 20),
                _subjectSection(
                  title: 'AYT · Resmî dersler',
                  subjects: officialAyt,
                  color: colors.tertiary,
                ),
              ],
              if (extraTyt.isNotEmpty) ...[
                const SizedBox(height: 20),
                _subjectSection(
                  title: 'Kişisel TYT ek dersleri · resmî toplama dahil değil',
                  subjects: extraTyt,
                  color: colors.primary,
                ),
              ],
              if (extraAyt.isNotEmpty) ...[
                const SizedBox(height: 20),
                _subjectSection(
                  title: 'Kişisel AYT ek dersleri · resmî toplama dahil değil',
                  subjects: extraAyt,
                  color: colors.secondary,
                ),
              ],
              if (tytSubjects.isEmpty && aytSubjects.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 32),
                  child: Text('Bu profilde net girilebilecek ders bulunamadı.'),
                ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _summaryCard(
    double tytNet,
    List<Subject> tytSubjects,
    double aytNet,
    List<Subject> aytSubjects, {
    required double extraTytNet,
    required double extraAytNet,
    required bool hasExtraSubjects,
  }) {
    final tytQuestions = tytSubjects.fold<int>(
      0,
      (total, subject) => total + subject.totalQuestions,
    );
    final aytQuestions = aytSubjects.fold<int>(
      0,
      (total, subject) => total + subject.totalQuestions,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Girdiğin netler',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _summaryValue(
                  'TYT',
                  tytNet,
                  tytQuestions,
                  AppTheme.accentGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryValue(
                  'AYT',
                  aytNet,
                  aytQuestions,
                  AppTheme.accentOrange,
                ),
              ),
            ],
          ),
          if (hasExtraSubjects) ...[
            const SizedBox(height: 12),
            Text(
              'Kişisel ek ders netleri (resmî TYT/AYT toplamına dahil değil): '
              'TYT ${NetScore.format(extraTytNet)} · AYT ${NetScore.format(extraAytNet)}',
              style: const TextStyle(color: Colors.white60, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }

  Widget _summaryValue(String label, double value, int maximum, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          '${NetScore.format(value)} / $maximum net',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _subjectSection({
    required String title,
    required List<Subject> subjects,
    required Color color,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: colors.onSurface),
        ),
        const SizedBox(height: 12),
        for (final subject in subjects) _subjectNetSlider(subject, color),
      ],
    );
  }

  Widget _subjectNetSlider(Subject subject, Color color) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final questionCount = subject.totalQuestions < 0
        ? 0
        : subject.totalQuestions;
    final maximum = questionCount > 0 ? questionCount : 1;
    final minimum = NetScore.minimumForQuestionCount(questionCount);
    final key = _keyFor(subject);
    final value = _netFor(
      subject,
    ).clamp(minimum, questionCount.toDouble()).toDouble();
    final controller = _netControllers.putIfAbsent(
      key,
      () => TextEditingController(text: NetScore.format(value)),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  subject.name,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${NetScore.format(value)} / ${subject.totalQuestions}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: value,
                  min: minimum,
                  max: maximum.toDouble(),
                  divisions: questionCount > 0 ? questionCount * 5 : 4,
                  label: NetScore.format(value),
                  activeColor: color,
                  onChanged: questionCount == 0
                      ? null
                      : (nextValue) {
                          final snapped = (nextValue * 4).round() / 4.0;
                          setState(() {
                            _nets[key] = snapped;
                            _netErrors.remove(key);
                            controller.value = TextEditingValue(
                              text: NetScore.format(snapped),
                              selection: TextSelection.collapsed(
                                offset: NetScore.format(snapped).length,
                              ),
                            );
                          });
                        },
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 82,
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurface,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Net',
                    errorText: _netErrors[key],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                  ),
                  onChanged: (rawValue) {
                    final parsed = NetScore.parse(rawValue);
                    final error = NetScore.validationError(
                      parsed,
                      questionCount,
                    );
                    setState(() {
                      if (error == null && parsed != null) {
                        _nets[key] = parsed;
                        _netErrors.remove(key);
                      } else {
                        _netErrors[key] = error!;
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
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
