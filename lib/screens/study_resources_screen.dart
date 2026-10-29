import '../theme/app_motion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/learning_workspace.dart';
import '../providers/app_state.dart';
import '../utils/turkish_date.dart';
import '../widgets/date_picker_field.dart';
import 'resources_screen.dart';
import 'pomodoro_screen.dart';
import 'resource_plan_screen.dart';

int _sequence = 0;
String _id(String kind) =>
    '$kind-${DateTime.now().microsecondsSinceEpoch}-${_sequence++}';
int _number(TextEditingController controller) {
  final value = int.tryParse(controller.text.trim());
  if (value == null) throw const FormatException('Tam sayı gir.');
  return value;
}

Widget _field(
  TextEditingController controller,
  String label,
  bool busy, {
  bool number = false,
  bool locked = false,
}) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 7),
  child: TextField(
    controller: controller,
    enabled: !busy && !locked,
    keyboardType: number ? TextInputType.number : TextInputType.text,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
  ),
);

/// A failed durable write keeps the editor and its draft open.
Future<void> _editor(
  BuildContext context,
  String title,
  Widget Function(StateSetter, bool) fields,
  Future<bool> Function() save,
) async {
  final state = context.read<AppState>();
  final profile = state.activeProfile.id;
  bool busy = false;
  String? error;
  final route = DialogRoute<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, refresh) => PopScope(
        canPop: !busy,
        child: AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  fields(refresh, busy),
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
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
          ),
          actions: [
            TextButton(
              onPressed: busy ? null : () => Navigator.pop(context),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: busy
                  ? null
                  : () async {
                      refresh(() {
                        busy = true;
                        error = null;
                      });
                      bool success = false;
                      try {
                        if (state.activeProfile.id != profile ||
                            state.isProfileTransitioning) {
                          throw const FormatException(
                            'Profil değişti. Bu pencereyi kapatıp yeniden aç.',
                          );
                        }
                        success = await save();
                        if (!success) {
                          error =
                              state.learningWorkspaceError ??
                              'Kayıt yapılamadı. Yeniden dene.';
                        }
                      } on FormatException catch (exception) {
                        error = exception.message;
                      } catch (_) {
                        error = 'Kayıt yapılamadı. Yeniden dene.';
                      }
                      if (!context.mounted) return;
                      if (success) {
                        Navigator.pop(context);
                      } else {
                        refresh(() => busy = false);
                      }
                    },
              child: Text(busy ? 'Kaydediliyor…' : 'Kaydet'),
            ),
          ],
        ),
      ),
    ),
  );
  await Navigator.of(context, rootNavigator: true).push(route);
  // Keep field controllers alive through the route's exit animation.
  await route.completed;
}

Future<void> _resourceEditor(
  BuildContext context, [
  StudyResource? resource,
]) async {
  final state = context.read<AppState>();
  final name = TextEditingController(text: resource?.name);
  final publisher = TextEditingController(text: resource?.publisher);
  final total = TextEditingController(
    text: resource?.totalUnits.toString() ?? '100',
  );
  final initial = TextEditingController(
    text: resource?.initialCompletedUnits.toString() ?? '0',
  );
  final subjects = state.resourceSubjects;
  String? subjectId = resource?.subjectId ?? subjects.firstOrNull?.storageId;
  var unit = resource?.unit ?? StudyResourceUnit.page;
  final locked =
      resource != null &&
      (resource.initialCompletedUnits > 0 ||
          state.learningWorkspace.tasks.any(
            (task) => task.resourceId == resource.id,
          ));
  final id = resource?.id ?? _id('resource');
  try {
    await _editor(
      context,
      resource == null ? 'Kaynak ekle' : 'Kaynağı düzenle',
      (refresh, busy) => Column(
        children: [
          _field(name, 'Kaynak adı', busy),
          _field(publisher, 'Yayınevi / kanal (isteğe bağlı)', busy),
          DropdownButtonFormField<String>(
            initialValue: subjectId,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Ders / oturum'),
            items: [
              for (final subject in subjects)
                DropdownMenuItem(
                  value: subject.storageId,
                  child: Text(
                    '${subject.type} · ${subject.name}${subject.isCustom ? ' (kişisel)' : ''}',
                  ),
                ),
              if (resource != null &&
                  !subjects.any(
                    (subject) => subject.storageId == resource.subjectId,
                  ))
                DropdownMenuItem(
                  value: resource.subjectId,
                  child: Text('${resource.session} · ${resource.subjectName}'),
                ),
            ],
            onChanged: busy || locked
                ? null
                : (value) => refresh(() => subjectId = value),
          ),
          DropdownButtonFormField<StudyResourceUnit>(
            initialValue: unit,
            decoration: const InputDecoration(labelText: 'İlerleme birimi'),
            items: [
              for (final value in StudyResourceUnit.values)
                DropdownMenuItem(value: value, child: Text(value.label)),
            ],
            onChanged: busy || locked
                ? null
                : (value) => refresh(() => unit = value!),
          ),
          _field(total, 'Toplam birim', busy, number: true),
          _field(
            initial,
            'Başlamadan önce bitirdiğin ilk birim sayısı',
            busy,
            number: true,
            locked: locked,
          ),
          if (locked)
            const Text(
              'Çalışma geçmişini korumak için ders, birim ve başlangıç ilerlemesi sabit.',
            ),
        ],
      ),
      () async {
        final subject = subjects
            .where((subject) => subject.storageId == subjectId)
            .firstOrNull;
        if (subjectId == null) throw const FormatException('Ders seç.');
        return state.saveStudyResource(
          StudyResource(
            id: id,
            name: name.text.trim(),
            publisher: publisher.text.trim(),
            subjectId: subjectId!,
            subjectName: subject?.name ?? resource!.subjectName,
            session: subject?.type ?? resource!.session,
            unit: unit,
            totalUnits: _number(total),
            initialCompletedUnits: _number(initial),
            archived: resource?.archived ?? false,
          ),
        );
      },
    );
  } finally {
    for (final controller in [name, publisher, total, initial]) {
      controller.dispose();
    }
  }
}

Future<void> _taskEditor(
  BuildContext context,
  StudyResource resource, [
  ResourceTask? task,
]) async {
  final state = context.read<AppState>();
  final existing = state.learningWorkspace.tasks.where(
    (task) => task.resourceId == resource.id,
  );
  final next =
      existing.fold(
        resource.initialCompletedUnits,
        (int end, task) => task.endUnit > end ? task.endUnit : end,
      ) +
      1;
  final title = TextEditingController(text: task?.title ?? '');
  final start = TextEditingController(
    text: (task?.startUnit ?? next).toString(),
  );
  final end = TextEditingController(text: (task?.endUnit ?? next).toString());
  final minutes = TextEditingController(
    text: task?.estimatedMinutes.toString() ?? '30',
  );
  final day = TextEditingController(text: task?.plannedDate ?? '');
  final locked =
      task != null &&
      (state.learningWorkspace.events.any((event) => event.taskId == task.id) ||
          state.learningWorkspace.plans.any(
            (day) => day.blocks.any((block) => block.taskId == task.id),
          ));
  final id = task?.id ?? _id('task');
  final topics = state.subjects
      .where((subject) => subject.storageId == resource.subjectId)
      .expand((subject) => subject.topics)
      .toList();
  String? topicId = task?.topicId;
  String? topicName = task?.topicName;
  try {
    await _editor(
      context,
      task == null ? 'Görev ekle' : 'Görevi düzenle',
      (refresh, busy) => Column(
        children: [
          _field(title, 'Görev adı / konu', busy),
          DropdownButtonFormField<String>(
            initialValue: topicId ?? '',
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Bağlı konu (isteğe bağlı)',
            ),
            items: [
              const DropdownMenuItem(value: '', child: Text('Konu seçilmedi')),
              for (final topic in topics)
                DropdownMenuItem(value: topic.id, child: Text(topic.name)),
              if (topicId != null && !topics.any((t) => t.id == topicId))
                DropdownMenuItem(
                  value: topicId,
                  child: Text('$topicName (katalogdan kaldırılmış)'),
                ),
            ],
            onChanged: busy
                ? null
                : (value) => refresh(() {
                    topicId = value == '' ? null : value;
                    topicName =
                        topics
                            .where((t) => t.id == topicId)
                            .firstOrNull
                            ?.name ??
                        (topicId == null ? null : topicName);
                  }),
          ),
          _field(
            start,
            'İlk ${resource.unit.label} (dahil)',
            busy,
            number: true,
            locked: locked,
          ),
          _field(
            end,
            'Son ${resource.unit.label} (dahil)',
            busy,
            number: true,
            locked: locked,
          ),
          _field(minutes, 'Tahmini toplam dakika', busy, number: true),
          DatePickerField(
            label: 'Çalışma günü (isteğe bağlı)',
            value: day.text.trim().isEmpty ? null : day.text.trim(),
            optional: true,
            enabled: !busy,
            firstDate: _earliestPlannedDate(task?.plannedDate),
            lastDate: DateTime(DateTime.now().year + 5, 12, 31),
            helpText: 'Görevin en erken çalışma günü',
            onChanged: (value) => refresh(() => day.text = value ?? ''),
          ),
          const Text('Plan oluşturduğunda bu tarihten önceye yerleştirilmez.'),
        ],
      ),
      () => state.saveResourceTask(
        ResourceTask(
          id: id,
          resourceId: resource.id,
          title: title.text.trim(),
          startUnit: _number(start),
          endUnit: _number(end),
          estimatedMinutes: _number(minutes),
          plannedDate: day.text.trim().isEmpty ? null : day.text.trim(),
          topicId: topicId,
          topicName: topicName,
          archived: task?.archived ?? false,
        ),
      ),
    );
  } finally {
    for (final controller in [title, start, end, minutes, day]) {
      controller.dispose();
    }
  }
}

/// Geçmiş tarihli eski bir görev düzenlenirken mevcut değer seçilebilir kalsın.
DateTime _earliestPlannedDate(String? existing) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final current = parseIsoDay(existing);
  return current != null && current.isBefore(today) ? current : today;
}

int _defaultUnitsPerTask(StudyResourceUnit unit) => switch (unit) {
  StudyResourceUnit.page => 20,
  StudyResourceUnit.test => 2,
  StudyResourceUnit.question => 40,
  StudyResourceUnit.video => 3,
};

/// Kaynağın görevlere ayrılmamış kısmını eşit görevlere böler.
Future<void> _splitEditor(BuildContext context, StudyResource resource) async {
  final state = context.read<AppState>();
  final per = TextEditingController(
    text: _defaultUnitsPerTask(resource.unit).toString(),
  );
  final minutes = TextEditingController(text: '60');
  final prefix = TextEditingController(text: 'Bölüm');
  final idPrefix = _id('task');
  final unit = resource.unit.label;
  String preview() {
    final ranges = state.learningWorkspace.unassignedRanges(resource.id);
    if (ranges.isEmpty) return 'Bu kaynağın tüm aralığı görevlere ayrılmış.';
    final free = ranges.fold<int>(0, (sum, r) => sum + r.$2 - r.$1 + 1);
    final size = int.tryParse(per.text.trim());
    final rangeText = ranges.map((r) => '${r.$1}–${r.$2}').join(', ');
    if (size == null || size < 1) {
      return 'Boştaki aralık: $rangeText ($free $unit).';
    }
    final count = ranges.fold<int>(
      0,
      (sum, r) => sum + ((r.$2 - r.$1 + 1) + size - 1) ~/ size,
    );
    return 'Boştaki aralık: $rangeText ($free $unit) → $count görev. '
        'Mevcut görevlere ve çalışma geçmişine dokunulmaz.';
  }

  try {
    await _editor(
      context,
      'Otomatik böl',
      (_, busy) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _field(per, 'Her görevde kaç $unit', busy, number: true),
          _field(minutes, 'Görev başına tahmini dakika', busy, number: true),
          _field(prefix, 'Görev adı (ör. Bölüm, Test)', busy),
          ListenableBuilder(
            listenable: Listenable.merge([per]),
            builder: (context, _) => Text(preview()),
          ),
        ],
      ),
      () => state.saveResourceTasks(
        state.learningWorkspace.splitUnassigned(
          resourceId: resource.id,
          unitsPerTask: _number(per),
          minutesPerTask: _number(minutes),
          titlePrefix: prefix.text,
          idPrefix: idPrefix,
        ),
      ),
    );
  } finally {
    for (final controller in [per, minutes, prefix]) {
      controller.dispose();
    }
  }
}

Future<void> _progressEditor(
  BuildContext context,
  StudyResource resource,
  ResourceTask task,
) async {
  final state = context.read<AppState>();
  final ranges = state.learningWorkspace.remainingRanges(task.id);
  if (ranges.isEmpty) return;
  final range = ranges.first;
  final count = TextEditingController(
    text: (range.$2 - range.$1 + 1).toString(),
  );
  final id = _id('progress');
  final at = DateTime.now().toUtc();
  try {
    await _editor(
      context,
      'İlerleme kaydet',
      (_, busy) => Column(
        children: [
          Text(
            'Sıradaki açık aralık: ${range.$1}–${range.$2} ${resource.unit.label}. Başlangıç: ${range.$1}.',
          ),
          _field(count, 'Bitirdiğin ardışık birim sayısı', busy, number: true),
          const Text('Odak süresi ve bitirilen birim ayrı kaydedilir.'),
        ],
      ),
      () {
        final units = _number(count);
        if (units < 1 || units > range.$2 - range.$1 + 1) {
          throw const FormatException(
            'Açık aralığı aşmayan pozitif bir sayı gir.',
          );
        }
        return state.recordResourceProgress(
          ResourceProgressEvent(
            id: id,
            taskId: task.id,
            startUnit: range.$1,
            units: units,
            occurredAt: at,
          ),
        );
      },
    );
  } finally {
    count.dispose();
  }
}

class StudyResourcesScreen extends StatefulWidget {
  const StudyResourcesScreen({super.key});
  @override
  State<StudyResourcesScreen> createState() => _StudyResourcesScreenState();
}

class _StudyResourcesScreenState extends State<StudyResourcesScreen> {
  bool archived = false;
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final workspace = state.learningWorkspace;
    final resources = workspace.resources
        .where((resource) => resource.archived == archived)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kaynaklarım'),
        actions: [
          IconButton(
            tooltip: 'Çalışma rehberi',
            icon: const Icon(Icons.help_outline),
            onPressed: () => Navigator.push(
              context,
              AppPageRoute(builder: (_) => const ResourcesScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: state.isProfileTransitioning
            ? null
            : () => _resourceEditor(context),
        icon: const Icon(Icons.add),
        label: const Text('Kaynak ekle'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          const Text(
            'Kitabını, soru bankanı veya video serini ekle. Tamamladığın aralıkları kaydet.',
          ),
          TextButton.icon(
            onPressed: () => Navigator.push(
              context,
              AppPageRoute(builder: (_) => const ResourcePlanScreen()),
            ),
            icon: const Icon(Icons.route_outlined),
            label: const Text('Kaynaklardan günlük plan'),
          ),
          SwitchListTile(
            title: const Text('Arşivdekileri göster'),
            value: archived,
            onChanged: (value) => setState(() => archived = value),
          ),
          if (resources.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                archived
                    ? 'Arşivde kaynak yok.'
                    : 'Henüz kaynak eklemedin. İlk kaynağınla başla.',
              ),
            ),
          for (final resource in resources)
            Card(
              child: ListTile(
                title: Text(resource.name),
                subtitle: Text(
                  '${resource.session} · ${resource.subjectName}\n${workspace.resourceProgress(resource.id)} / ${resource.totalUnits} ${resource.unit.label}',
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  AppPageRoute(
                    builder: (_) => StudyResourceDetail(
                      resourceId: resource.id,
                      profileId: state.activeProfile.id,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class StudyResourceDetail extends StatefulWidget {
  final String resourceId, profileId;
  const StudyResourceDetail({
    super.key,
    required this.resourceId,
    required this.profileId,
  });
  @override
  State<StudyResourceDetail> createState() => _ResourceDetailState();
}

class _ResourceDetailState extends State<StudyResourceDetail> {
  bool busy = false;
  Future<void> _change(Future<bool> Function(AppState) operation) async {
    final state = context.read<AppState>();
    if (busy ||
        state.activeProfile.id != widget.profileId ||
        state.isProfileTransitioning) {
      return;
    }
    setState(() => busy = true);
    final ok = await operation(state);
    if (!mounted) return;
    setState(() => busy = false);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.learningWorkspaceError ?? 'Kayıt yapılamadı. Yeniden dene.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final workspace = state.learningWorkspace;
    final resource = workspace.resources
        .where((resource) => resource.id == widget.resourceId)
        .firstOrNull;
    if (resource == null || state.activeProfile.id != widget.profileId) {
      return Scaffold(
        appBar: AppBar(title: const Text('Kaynak')),
        body: const Center(
          child: Text('Profil değişti. Kaynak listesine dön.'),
        ),
      );
    }
    final tasks = workspace.tasks
        .where((task) => task.resourceId == resource.id)
        .toList();
    final ids = tasks.map((task) => task.id).toSet();
    final events =
        workspace.events.where((event) => ids.contains(event.taskId)).toList()
          ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    final disabled = busy || state.isProfileTransitioning;
    return Scaffold(
      appBar: AppBar(title: Text(resource.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${resource.session} · ${resource.subjectName} · ${resource.publisher}',
          ),
          Text(
            '${workspace.resourceProgress(resource.id)} / ${resource.totalUnits} ${resource.unit.label}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton(
                onPressed: disabled
                    ? null
                    : () => _resourceEditor(context, resource),
                child: const Text('Düzenle'),
              ),
              OutlinedButton(
                onPressed: disabled
                    ? null
                    : () => _change(
                        (state) => state.archiveStudyResource(
                          resource.id,
                          !resource.archived,
                        ),
                      ),
                child: Text(
                  resource.archived ? 'Arşivden çıkar' : 'Kaynağı arşivle',
                ),
              ),
              FilledButton(
                onPressed: disabled || resource.archived
                    ? null
                    : () => _taskEditor(context, resource),
                child: const Text('Görev ekle'),
              ),
              OutlinedButton.icon(
                onPressed:
                    disabled ||
                        resource.archived ||
                        workspace.unassignedRanges(resource.id).isEmpty
                    ? null
                    : () => _splitEditor(context, resource),
                icon: const Icon(Icons.call_split_rounded, size: 18),
                label: const Text('Otomatik böl'),
              ),
            ],
          ),
          if (tasks.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Bir aralık seçerek ilk görevini ekle ya da “Otomatik böl” ile '
                'kaynağı tek seferde eşit görevlere ayır.',
              ),
            ),
          for (final task in tasks)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${task.title}${task.archived ? ' · Arşivde' : ''}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (task.topicId != null)
                      Text(
                        'Konu: ${state.subjects.where((s) => s.storageId == resource.subjectId).expand((s) => s.topics).where((t) => t.id == task.topicId).firstOrNull?.name ?? task.topicName}',
                      ),
                    Text(
                      '${task.startUnit}–${task.endUnit} ${resource.unit.label} · ${workspace.taskProgress(task.id)} / ${task.unitCount} tamamlandı',
                    ),
                    Text(
                      'Tahmini ${task.estimatedMinutes} dakika${task.plannedDate == null ? '' : ' · En erken: ${turkishDayKey(task.plannedDate!)}'}',
                    ),
                    Wrap(
                      spacing: 8,
                      children: [
                        FilledButton(
                          onPressed:
                              disabled ||
                                  resource.archived ||
                                  task.archived ||
                                  workspace.remainingRanges(task.id).isEmpty
                              ? null
                              : () => _progressEditor(context, resource, task),
                          child: const Text('İlerleme ekle'),
                        ),
                        TextButton(
                          onPressed:
                              disabled || task.archived || resource.archived
                              ? null
                              : () => Navigator.push(
                                  context,
                                  AppPageRoute(
                                    builder: (_) => PomodoroScreen(
                                      autoStart: true,
                                      taskTitle:
                                          '${resource.name} · ${task.title}',
                                      taskId: 'resource:${task.id}',
                                    ),
                                  ),
                                ),
                          child: const Text('Odaklan'),
                        ),
                        TextButton(
                          onPressed: disabled
                              ? null
                              : () => _taskEditor(context, resource, task),
                          child: const Text('Düzenle'),
                        ),
                        TextButton(
                          onPressed: disabled
                              ? null
                              : () => _change(
                                  (state) => state.archiveResourceTask(
                                    task.id,
                                    !task.archived,
                                  ),
                                ),
                          child: Text(
                            task.archived ? 'Arşivden çıkar' : 'Arşivle',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          if (events.isNotEmpty)
            ExpansionTile(
              title: Text('Son çalışma kayıtları (${events.length})'),
              children: [
                for (final event in events.take(20))
                  ListTile(
                    title: Text(
                      '${event.startUnit}–${event.endUnit} ${resource.unit.label} · ${tasks.firstWhere((task) => task.id == event.taskId).title}',
                    ),
                    subtitle: Text(
                      '${event.occurredAt.toLocal().toString().substring(0, 16)}${event.active ? '' : ' · Geri alındı'}',
                    ),
                    trailing: event.active
                        ? TextButton(
                            onPressed: disabled
                                ? null
                                : () => _change(
                                    (state) =>
                                        state.undoResourceProgress(event.id),
                                  ),
                            child: const Text('Geri al'),
                          )
                        : null,
                  ),
                if (events.length > 20)
                  const Text(
                    'Burada son 20 kayıt gösterilir. Tüm kayıtlar yedekte korunur.',
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
