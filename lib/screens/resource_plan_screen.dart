import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/resource_plan.dart';
import '../providers/app_state.dart';
import 'daily_plan_screen.dart';
import 'study_resources_screen.dart';
import 'settings_screen.dart';

class ResourceTodayCard extends StatelessWidget {
  const ResourceTodayCard({super.key});
  @override
  Widget build(BuildContext context) {
    final workspace = context.watch<AppState>().learningWorkspace;
    final today = resourceDayKey(DateTime.now());
    final day = workspace.plans.where((day) => day.date == today).firstOrNull;
    final next = day?.blocks
        .where((block) => workspace.blockProgress(day, block) < block.units)
        .firstOrNull;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BUGÜNÜN KAYNAK PLANI',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Text(
              day == null
                  ? 'Kaynak görevlerinden günlük plan oluştur.'
                  : next == null
                  ? (day.blocks.isEmpty
                        ? 'Bugüne kaynak görevi ayrılmadı.'
                        : 'Bugünün kaynak planı tamamlandı.')
                  : '${next.resourceName} · ${next.title}',
            ),
            if (next != null)
              Text(
                '${next.startUnit}–${next.endUnit} ${next.unitLabel} · yaklaşık ${next.estimatedMinutes} dakika',
              ),
            if (day != null)
              Text(
                '${day.plannedMinutes} / ${day.capacityMinutes} dakika planlandı',
              ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ResourcePlanScreen()),
              ),
              icon: const Icon(Icons.route_outlined),
              label: const Text('Kaynak planını aç'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResourcePlanScreen extends StatefulWidget {
  const ResourcePlanScreen({super.key});
  @override
  State<ResourcePlanScreen> createState() => _ResourcePlanScreenState();
}

class _ResourcePlanScreenState extends State<ResourcePlanScreen> {
  bool busy = false;
  Future<void> _save(Future<bool> Function(AppState) save) async {
    final state = context.read<AppState>();
    if (busy || state.isProfileTransitioning) return;
    setState(() => busy = true);
    final ok = await save(state);
    if (!mounted) return;
    setState(() => busy = false);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.learningWorkspaceError ?? 'Plan kaydedilemedi. Yeniden dene.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final workspace = state.learningWorkspace;
    final today = resourceDayKey(DateTime.now());
    final days = workspace.plans.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final missed = days
        .where(
          (day) =>
              day.date.compareTo(today) < 0 &&
              day.blocks.any(
                (block) => workspace.blockProgress(day, block) < block.units,
              ),
        )
        .length;
    final disabled = busy || state.isProfileTransitioning;
    return Scaffold(
      appBar: AppBar(title: const Text('Kaynaklardan günlük plan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Günlük kapasite: ${state.schedulePreferences.dailyStudyMinutes} dakika. Birim süreleri görevde belirttiğin tahmine dayanır.',
          ),
          const Text(
            'Bugün ve geçmiş günler korunur. Güncelleme yalnız yarından itibaren dağılımı değiştirir. Geçmişte yetişmeyen iş uygun sonraki günlere taşınır; geçmiş beklenti silinmez.',
          ),
          Wrap(
            spacing: 8,
            children: [
              FilledButton(
                onPressed: disabled
                    ? null
                    : () => _save((state) => state.rebuildResourcePlan()),
                child: Text(
                  busy ? 'Kaydediliyor…' : 'Plan oluştur / geleceği güncelle',
                ),
              ),
              TextButton(
                onPressed: disabled
                    ? null
                    : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      ),
                child: const Text('Kapasite ve hedef tarihi'),
              ),
              TextButton(
                onPressed: disabled
                    ? null
                    : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const DailyPlanScreen(showLegacy: true),
                        ),
                      ),
                child: const Text('Eski şablon ve kayıtlar'),
              ),
            ],
          ),
          if (workspace.unplannedUnits > 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                '${workspace.unplannedUnits} birim plana sığmadı veya henüz planlanmadı. Tarihi/kapasiteyi kontrol et. Tek birimi günlük süreden uzun görevler zorla bölünmez.',
              ),
            ),
          if (missed > 0)
            Text(
              '$missed geçmiş günde beklenen aralıklar gününde bitirilmedi. Sonraki çalışma geçmiş günü tamamlanmış göstermez.',
            ),
          if (days.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('Önce kaynağına görev ekle, ardından plan oluştur.'),
            ),
          for (final day in days)
            Card(
              child: ExpansionTile(
                key: PageStorageKey('${state.activeProfile.id}:${day.date}'),
                initiallyExpanded: day.date == today,
                title: Text(
                  '${day.date}${day.date == today ? ' · Bugün' : ''}',
                ),
                subtitle: Text(
                  '${day.plannedMinutes} / ${day.capacityMinutes} dakika · ${day.blocks.where((block) => workspace.blockProgress(day, block) == block.units).length} / ${day.blocks.length} aralık tamamlandı',
                ),
                children: [
                  if (day.blocks.isEmpty)
                    const ListTile(
                      title: Text('Bu gün için kaynak görevi ayrılmadı.'),
                    ),
                  for (final block in day.blocks)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${block.resourceName} · ${block.title}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${block.startUnit}–${block.endUnit} ${block.unitLabel} · ${block.estimatedMinutes} dakika · ${workspace.blockProgress(day, block)} / ${block.units}',
                          ),
                          Wrap(
                            spacing: 8,
                            children: [
                              FilledButton(
                                onPressed:
                                    disabled ||
                                        day.date != today ||
                                        workspace.blockProgress(day, block) ==
                                            block.units ||
                                        workspace.tasks
                                            .firstWhere(
                                              (task) => task.id == block.taskId,
                                            )
                                            .archived ||
                                        workspace.resources
                                            .firstWhere(
                                              (resource) =>
                                                  resource.id ==
                                                  workspace.tasks
                                                      .firstWhere(
                                                        (task) =>
                                                            task.id ==
                                                            block.taskId,
                                                      )
                                                      .resourceId,
                                            )
                                            .archived
                                    ? null
                                    : () => _save(
                                        (state) =>
                                            state.completeResourcePlanBlock(
                                              day.date,
                                              block.taskId,
                                              block.startUnit,
                                              block.endUnit,
                                            ),
                                      ),
                                child: const Text('Aralığı tamamla'),
                              ),
                              TextButton(
                                onPressed: disabled
                                    ? null
                                    : () {
                                        final task = workspace.tasks.firstWhere(
                                          (task) => task.id == block.taskId,
                                        );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => StudyResourceDetail(
                                              resourceId: task.resourceId,
                                              profileId: state.activeProfile.id,
                                            ),
                                          ),
                                        );
                                      },
                                child: const Text('Kısmi ilerleme / geçmiş'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
