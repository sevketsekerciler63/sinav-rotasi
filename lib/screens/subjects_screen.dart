import '../widgets/profile_save_form.dart';
import '../theme/app_motion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/subject.dart';
import '../models/topic.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  String _searchQuery = '';
  String _selectedExamType = 'TYT';

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final colors = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Konular'),
              bottom: TabBar(
                indicatorColor: colors.primary,
                labelColor: colors.primary,
                unselectedLabelColor: colors.onSurfaceVariant,
                onTap: (index) => setState(
                  () => _selectedExamType = index == 0 ? 'TYT' : 'AYT',
                ),
                tabs: [
                  Tab(
                    text:
                        'TYT (${state.tytSubjects.fold(0, (s, sub) => s + sub.completedCount)}/${state.tytSubjects.fold(0, (s, sub) => s + sub.topics.length)})',
                  ),
                  Tab(
                    text:
                        'AYT (${state.aytSubjects.fold(0, (s, sub) => s + sub.completedCount)}/${state.aytSubjects.fold(0, (s, sub) => s + sub.topics.length)})',
                  ),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: 'Ders veya konu ekle',
                  onPressed: () => _showAddOptions(context, state),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            body: Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: TextField(
                    onChanged: (v) =>
                        setState(() => _searchQuery = v.toLowerCase()),
                    decoration: InputDecoration(
                      hintText: 'Konu ara... (${state.totalTopics} konu)',
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontSize: 13,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: colors.onSurfaceVariant,
                        size: 20,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              tooltip: 'Aramayı temizle',
                              onPressed: () =>
                                  setState(() => _searchQuery = ''),
                              icon: Icon(
                                Icons.close,
                                color: colors.onSurfaceVariant,
                                size: 18,
                              ),
                            )
                          : null,
                      filled: true,
                      fillColor: colors.surfaceContainerLow,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: colors.outlineVariant),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: colors.outlineVariant),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _searchQuery.isNotEmpty
                      ? _buildSearchResults(context, state)
                      : TabBarView(
                          children: [
                            _buildSubjectList(context, state.tytSubjects),
                            _buildSubjectList(context, state.aytSubjects),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddOptions(BuildContext context, AppState state) async {
    final examType = _selectedExamType;
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.library_add,
                color: Theme.of(sheetContext).colorScheme.primary,
              ),
              title: Text('$examType dersi ekle'),
              onTap: () => Navigator.pop(sheetContext, 'subject'),
            ),
            ListTile(
              leading: Icon(
                Icons.topic_outlined,
                color: Theme.of(sheetContext).colorScheme.secondary,
              ),
              title: const Text('Bir derse konu ekle'),
              onTap: () => Navigator.pop(sheetContext, 'topic'),
            ),
          ],
        ),
      ),
    );
    if (!context.mounted || action == null) return;
    if (action == 'subject') {
      await _showAddSubjectDialog(context, state, examType);
    } else {
      final subjects = examType == 'TYT'
          ? state.tytSubjects
          : state.aytSubjects;
      if (subjects.isEmpty) return;
      final subject = await _chooseSubject(context, subjects);
      if (!context.mounted || subject == null) return;
      await _showTopicEditorDialog(context, state, subject);
    }
  }

  Future<void> _showAddSubjectDialog(
    BuildContext context,
    AppState state,
    String examType,
  ) async {
    final nameController = TextEditingController();
    final questionController = TextEditingController(text: '40');
    String? error;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('$examType dersi ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                maxLength: 50,
                decoration: const InputDecoration(labelText: 'Ders adı'),
              ),
              TextField(
                controller: questionController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Soru sayısı',
                  helperText: 'Bu sınav bölümündeki toplam soru sayısı',
                ),
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () async {
                final count = int.tryParse(questionController.text);
                if (nameController.text.trim().isEmpty || count == null) {
                  setDialogState(
                    () => error = 'Ders adını ve soru sayısını kontrol et.',
                  );
                  return;
                }
                try {
                  await state.addCustomSubject(
                    name: nameController.text,
                    type: examType,
                    totalQuestions: count,
                  );
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                } catch (exception) {
                  setDialogState(() => error = _friendlyError(exception));
                }
              },
              child: const Text('Dersi ekle'),
            ),
          ],
        ),
      ),
    );
    nameController.dispose();
    questionController.dispose();
  }

  Future<Subject?> _chooseSubject(
    BuildContext context,
    List<Subject> subjects,
  ) async {
    Subject selected = subjects.first;
    return showDialog<Subject>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Ders seç'),
          content: DropdownButtonFormField<String>(
            initialValue: selected.storageId,
            decoration: const InputDecoration(labelText: 'Ders'),
            items: subjects
                .map(
                  (subject) => DropdownMenuItem(
                    value: subject.storageId,
                    child: Text('${subject.emoji} ${subject.name}'),
                  ),
                )
                .toList(),
            onChanged: (id) => setDialogState(
              () => selected = subjects.firstWhere(
                (item) => item.storageId == id,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, selected),
              child: const Text('Devam'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showTopicEditorDialog(
    BuildContext context,
    AppState state,
    Subject subject, {
    Topic? topic,
  }) async {
    final nameController = TextEditingController(text: topic?.name ?? '');
    final descriptionController = TextEditingController(
      text: topic?.description ?? '',
    );
    final questionController = TextEditingController(
      text: '${topic?.questionCount ?? 10}',
    );
    final daysController = TextEditingController(
      text: '${topic?.estimatedDays ?? 1}',
    );
    String difficulty = topic?.difficulty ?? '🟡 Orta';
    String priority = topic?.priority ?? '🟡 ORTA';
    String? error;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(topic == null ? 'Konu ekle' : 'Konuyu düzenle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('${subject.emoji} ${subject.name}'),
                ),
                TextField(
                  controller: nameController,
                  autofocus: true,
                  maxLength: 70,
                  decoration: const InputDecoration(labelText: 'Konu adı'),
                ),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Kısa açıklama'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: questionController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Soru'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: daysController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Gün'),
                      ),
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  initialValue: difficulty,
                  decoration: const InputDecoration(labelText: 'Zorluk'),
                  items: const ['🟢 Kolay', '🟡 Orta', '🔴 Zor']
                      .map(
                        (value) =>
                            DropdownMenuItem(value: value, child: Text(value)),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => difficulty = value!),
                ),
                DropdownButtonFormField<String>(
                  initialValue: priority,
                  decoration: const InputDecoration(labelText: 'Öncelik'),
                  items:
                      const [
                            '🔴 ÇOK KRİTİK',
                            '🟠 ÖNEMLİ',
                            '🟡 ORTA',
                            '🔵 DÜŞÜK',
                          ]
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                  onChanged: (value) => setDialogState(() => priority = value!),
                ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () async {
                final questionCount = int.tryParse(questionController.text);
                final estimatedDays = int.tryParse(daysController.text);
                if (nameController.text.trim().isEmpty ||
                    questionCount == null ||
                    questionCount < 0 ||
                    estimatedDays == null ||
                    estimatedDays < 1) {
                  setDialogState(
                    () => error =
                        'Konu adını, soru sayısını ve gün değerini kontrol et.',
                  );
                  return;
                }
                try {
                  if (topic == null) {
                    await state.addCustomTopic(
                      subjectId: subject.storageId,
                      name: nameController.text,
                      description: descriptionController.text,
                      questionCount: questionCount,
                      difficulty: difficulty,
                      priority: priority,
                      estimatedDays: estimatedDays,
                    );
                  } else {
                    await state.updateCustomTopic(
                      subjectId: subject.storageId,
                      topicId: topic.id,
                      name: nameController.text,
                      description: descriptionController.text,
                      questionCount: questionCount,
                      difficulty: difficulty,
                      priority: priority,
                      estimatedDays: estimatedDays,
                    );
                  }
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                } catch (exception) {
                  setDialogState(() => error = _friendlyError(exception));
                }
              },
              child: Text(topic == null ? 'Konuyu ekle' : 'Kaydet'),
            ),
          ],
        ),
      ),
    );
    nameController.dispose();
    descriptionController.dispose();
    questionController.dispose();
    daysController.dispose();
  }

  String _friendlyError(Object exception) {
    final message = exception.toString();
    return message.startsWith('ArgumentError: ')
        ? message.substring('ArgumentError: '.length)
        : message;
  }

  Widget _buildSearchResults(BuildContext context, AppState state) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final results = <MapEntry<Subject, Topic>>[];
    for (var subject in state.subjects) {
      for (var topic in subject.topics) {
        if (topic.name.toLowerCase().contains(_searchQuery) ||
            topic.description.toLowerCase().contains(_searchQuery)) {
          results.add(MapEntry(subject, topic));
        }
      }
    }

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sonuç bulunamadı',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final entry = results[index];
        return _buildSearchResultCard(
          context,
          Provider.of<AppState>(context, listen: false),
          entry.key,
          entry.value,
        );
      },
    );
  }

  Widget _buildSearchResultCard(
    BuildContext context,
    AppState state,
    Subject subject,
    Topic topic,
  ) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: topic.isCompleted
            ? colors.secondary.withValues(alpha: 0.08)
            : colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: topic.isCompleted
              ? colors.secondary.withValues(alpha: 0.4)
              : colors.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: topic.isCompleted
                ? '${topic.name} tamamlandı. Tamamlandı durumunu kaldır.'
                : '${topic.name} konusunu tamamlandı olarak işaretle.',
            onPressed: state.isSavingRecord('topics_data', topic.id)
                ? null
                : () => showRecordResult(context, state.toggleTopic(topic.id)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: topic.isCompleted
                    ? colors.secondary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: topic.isCompleted
                      ? colors.secondary
                      : colors.outlineVariant,
                  width: 2,
                ),
              ),
              child: topic.isCompleted
                  ? Icon(Icons.check, color: colors.onSecondary, size: 16)
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.name,
                  style: textTheme.bodyMedium?.copyWith(
                    color: topic.isCompleted
                        ? colors.onSurfaceVariant
                        : colors.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '${subject.emoji} ${subject.name}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectList(BuildContext context, List<Subject> subjects) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.push(
              context,
              AppPageRoute(
                builder: (_) => SubjectDetailScreen(
                  subject: subject,
                  onEditTopic: (selectedSubject, {topic}) =>
                      _showTopicEditorDialog(
                        context,
                        Provider.of<AppState>(context, listen: false),
                        selectedSubject,
                        topic: topic,
                      ),
                ),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.getSubjectColor(
                      subject.name,
                    ).withValues(alpha: 0.15),
                    colors.surfaceContainerLow,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.getSubjectColor(
                    subject.name,
                  ).withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(subject.emoji, style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subject.name,
                              style: textTheme.titleSmall?.copyWith(
                                color: colors.onSurface,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${subject.totalQuestions} soru - ${subject.topics.length} konu',
                              style: textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: subject.progress == 1.0
                              ? colors.secondary.withValues(alpha: 0.18)
                              : colors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${(subject.progress * 100).toInt()}%',
                          style: TextStyle(
                            color: subject.progress == 1.0
                                ? colors.secondary
                                : colors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: subject.progress,
                      minHeight: 6,
                      backgroundColor: colors.outlineVariant,
                      valueColor: AlwaysStoppedAnimation(colors.primary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${subject.completedCount} tamamlandı, ${subject.topics.length - subject.completedCount} kaldı',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        '~${subject.remainingDays} gün',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SubjectDetailScreen extends StatelessWidget {
  final Subject subject;
  final Future<void> Function(Subject subject, {Topic? topic})? onEditTopic;

  const SubjectDetailScreen({
    super.key,
    required this.subject,
    this.onEditTopic,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final colors = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;
        final matchingSubjects = state.subjects.where(
          (item) => item.storageId == subject.storageId,
        );
        if (matchingSubjects.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Ders bulunamadı')),
            body: const Center(
              child: Text('Bu ders seçili profilde bulunmuyor.'),
            ),
          );
        }
        final activeSubject = matchingSubjects.first;
        return Scaffold(
          appBar: AppBar(
            title: Text('${activeSubject.emoji} ${activeSubject.name}'),
            actions: [
              if (onEditTopic != null)
                IconButton(
                  tooltip: 'Konu ekle',
                  onPressed: () => onEditTopic!(activeSubject),
                  icon: const Icon(Icons.add),
                ),
              if (activeSubject.isCustom)
                IconButton(
                  tooltip: 'Dersi sil',
                  onPressed: () =>
                      _confirmRemoveSubject(context, state, activeSubject),
                  icon: const Icon(Icons.delete_outline),
                ),
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    '${(activeSubject.progress * 100).toInt()}%',
                    style: textTheme.labelMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              if (activeSubject.tip.isNotEmpty)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colors.secondary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '*',
                        style: TextStyle(fontSize: 16, color: colors.tertiary),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          activeSubject.tip,
                          style: TextStyle(
                            color: colors.secondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: activeSubject.topics.length,
                  itemBuilder: (context, index) {
                    final topic = activeSubject.topics[index];
                    return _buildTopicCard(
                      context,
                      state,
                      activeSubject,
                      topic,
                      index + 1,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopicCard(
    BuildContext context,
    AppState state,
    Subject subject,
    Topic topic,
    int number,
  ) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final priorityColor =
        topic.priority.contains('KRiTiK') || topic.priority.contains('KR')
        ? colors.error
        : topic.priority.contains('ONEMLI') || topic.priority.contains('NEM')
        ? colors.tertiary
        : topic.priority.contains('ORTA')
        ? colors.secondary
        : colors.onSurfaceVariant;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: topic.isCompleted
            ? colors.secondary.withValues(alpha: 0.08)
            : colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: topic.isCompleted
              ? colors.secondary.withValues(alpha: 0.4)
              : colors.outlineVariant,
        ),
      ),
      child: ExpansionTile(
        leading: IconButton(
          tooltip: topic.isCompleted
              ? '${topic.name} tamamlandı. Tamamlandı durumunu kaldır.'
              : '${topic.name} konusunu tamamlandı olarak işaretle.',
          onPressed: state.isSavingRecord('topics_data', topic.id)
              ? null
              : () => showRecordResult(context, state.toggleTopic(topic.id)),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          icon: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: topic.isCompleted ? colors.secondary : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: topic.isCompleted
                    ? colors.secondary
                    : colors.outlineVariant,
                width: 2,
              ),
            ),
            child: topic.isCompleted
                ? Icon(Icons.check, color: colors.onSecondary, size: 18)
                : null,
          ),
        ),
        title: Text(
          '$number. ${topic.name}',
          style: textTheme.bodyMedium?.copyWith(
            color: topic.isCompleted
                ? colors.onSurfaceVariant
                : colors.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            decoration: topic.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: priorityColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                topic.priority,
                style: TextStyle(
                  color: priorityColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${topic.questionCount} soru · ${topic.estimatedDays} gün',
                style: textTheme.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
            if (topic.notes.isNotEmpty) ...[
              const SizedBox(width: 4),
              Icon(Icons.note, color: colors.tertiary, size: 14),
            ],
          ],
        ),
        iconColor: colors.onSurfaceVariant,
        collapsedIconColor: colors.onSurfaceVariant,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    topic.description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.onSurface,
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _infoChip(context, topic.difficulty),
                    const SizedBox(width: 6),
                    _infoChip(context, '${topic.questionCount} soru'),
                    const SizedBox(width: 6),
                    _infoChip(context, '~${topic.estimatedDays} gün'),
                  ],
                ),
                if (topic.sourceLabel != null && topic.sourceUrl != null) ...[
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () =>
                          _openTopicSource(context, topic.sourceUrl!),
                      icon: const Icon(Icons.open_in_new_rounded, size: 16),
                      label: Text('Kaynak: ${topic.sourceLabel}'),
                    ),
                  ),
                ],
                if (topic.isCustom && onEditTopic != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => onEditTopic!(subject, topic: topic),
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('Düzenle'),
                      ),
                      TextButton.icon(
                        onPressed: () =>
                            _confirmRemoveTopic(context, state, subject, topic),
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: const Text('Sil'),
                        style: TextButton.styleFrom(
                          foregroundColor: colors.error,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                // Notes section
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => _showNotesDialog(context, state, topic),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: topic.notes.isNotEmpty
                            ? colors.tertiaryContainer.withValues(alpha: 0.55)
                            : colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: topic.notes.isNotEmpty
                              ? colors.tertiary.withValues(alpha: 0.45)
                              : colors.outlineVariant,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            topic.notes.isNotEmpty
                                ? Icons.edit_note
                                : Icons.note_add_outlined,
                            color: topic.notes.isNotEmpty
                                ? colors.tertiary
                                : colors.onSurfaceVariant,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              topic.notes.isNotEmpty
                                  ? topic.notes
                                  : 'Not ekle...',
                              style: TextStyle(
                                color: topic.notes.isNotEmpty
                                    ? colors.onSurface
                                    : colors.onSurfaceVariant,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openTopicSource(BuildContext context, String rawUrl) async {
    final uri = Uri.tryParse(rawUrl);
    var opened = false;
    try {
      opened =
          uri != null &&
          (uri.scheme == 'https' || uri.scheme == 'http') &&
          await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      opened = false;
    }
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Kaynak açılamadı.')));
    }
  }

  Future<void> _confirmRemoveSubject(
    BuildContext context,
    AppState state,
    Subject subject,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Dersi ve konularını sil?'),
        content: Text(
          '“${subject.name}” ve içindeki konuların ilerlemesi bu profilden silinecek.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await state.removeCustomSubject(subject.storageId);
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> _confirmRemoveTopic(
    BuildContext context,
    AppState state,
    Subject subject,
    Topic topic,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konuyu sil?'),
        content: Text(
          '“${topic.name}” konusu ve bu konuya ait ilerleme silinecek.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await state.removeCustomTopic(
        subjectId: subject.storageId,
        topicId: topic.id,
      );
    }
  }

  Future<void> _showNotesDialog(
    BuildContext context,
    AppState state,
    Topic topic,
  ) async {
    final controller = TextEditingController(text: topic.notes);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    await showRetainedBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ProfileSaveForm(
        builder: (context, submit) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Not: ${topic.name}',
                style: textTheme.titleMedium?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 5,
                autofocus: true,
                decoration: InputDecoration(
                  hintText:
                      'Notlarını buraya yaz...\n(formül, kısa yol, önemli detay)',
                  hintStyle: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    submit(
                      () => state.updateTopicNotes(topic.id, controller.text),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Kaydet'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
    controller.dispose();
  }

  Widget _infoChip(BuildContext context, String text) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant),
      ),
    );
  }
}
