import '../widgets/profile_save_form.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/goal.dart';
import '../providers/app_state.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final colors = Theme.of(context).colorScheme;
        final active = state.goals.where((g) => !g.isCompleted).toList();
        final completed = state.goals.where((g) => g.isCompleted).toList();

        return Scaffold(
          appBar: AppBar(title: const Text('🎯 Hedeflerim')),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddGoalDialog(context, state),
            icon: const Icon(Icons.add),
            label: const Text('Hedef Ekle'),
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
          ),
          body: state.goals.isEmpty && state.quarantinedGoalRecords.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🎯', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      Text(
                        'Henüz hedef yok',
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Kendine hedefler koy ve takip et!',
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (active.isNotEmpty) ...[
                      Text(
                        '🏃 Devam Eden (${active.length})',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      ...active.map((g) => _goalCard(context, state, g)),
                    ],
                    if (completed.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        '✅ Tamamlanan (${completed.length})',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      ...completed.map((g) => _goalCard(context, state, g)),
                    ],
                    if (state.quarantinedGoalRecords.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        'Kurtarılan eski kayıtlar (${state.quarantinedGoalRecords.length})',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Okunamayan hedefler profilin açılmasını engellemez. Ham verileri yedeklerde korunur; istersen inceleyip kaldırabilirsin.',
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...state.quarantinedGoalRecords.indexed.map(
                        (entry) => _quarantinedGoalCard(
                          context,
                          state,
                          entry.$2,
                          entry.$1,
                        ),
                      ),
                    ],
                    const SizedBox(height: 80),
                  ],
                ),
        );
      },
    );
  }

  Widget _quarantinedGoalCard(
    BuildContext context,
    AppState state,
    Object? rawValue,
    int index,
  ) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: colors.errorContainer.withValues(alpha: 0.35),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Okunamayan hedef kaydı ${index + 1}',
              style: TextStyle(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Bu kayıt etkin hedef olarak yüklenemedi. Ham içerik yeni yedeklerde korunur.',
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                TextButton.icon(
                  onPressed: () => _showQuarantinedValue(context, rawValue),
                  icon: const Icon(Icons.data_object_outlined),
                  label: const Text('Ham veriyi gör'),
                ),
                TextButton.icon(
                  onPressed: () =>
                      _removeQuarantinedGoalWithUndo(context, state, index),
                  icon: Icon(Icons.delete_outline, color: colors.error),
                  label: Text(
                    'Kaydı kaldır',
                    style: TextStyle(color: colors.error),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showQuarantinedValue(BuildContext context, Object? rawValue) {
    final rawText = rawValue is String
        ? rawValue
        : const JsonEncoder.withIndent('  ').convert(rawValue);
    final preview = rawText.length > 4000
        ? '${rawText.substring(0, 4000)}\n… (önizleme kısaltıldı)'
        : rawText;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Korunan ham hedef verisi'),
        content: SizedBox(
          width: 560,
          child: SingleChildScrollView(child: SelectableText(preview)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  Future<void> _removeQuarantinedGoalWithUndo(
    BuildContext context,
    AppState state,
    int index,
  ) async {
    if (state.isProfileTransitioning ||
        index < 0 ||
        index >= state.quarantinedGoalRecords.length) {
      return;
    }
    final rawValue = state.quarantinedGoalRecords[index];
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Okunamayan hedefi kaldır?'),
        content: const Text(
          'Ham kayıt cihazdaki etkin listeden çıkarılır. Önce profil yedeği alabilir veya kaldırma sonrası kısa süre içinde geri alabilirsin.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Kaldır'),
          ),
        ],
      ),
    );
    if (shouldRemove != true || !context.mounted) return;
    final profileId = state.activeProfile.id;
    final saved = await state.removeQuarantinedGoalRecord(index);
    if (!context.mounted) return;
    if (!saved) {
      await showRecordResult(context, Future.value(false));
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Okunamayan hedef kaydı kaldırıldı.'),
          action: SnackBarAction(
            label: 'Geri al',
            onPressed: () => showRecordResult(
              context,
              state.restoreQuarantinedGoalRecord(
                rawValue,
                index: index,
                profileId: profileId,
              ),
            ),
          ),
        ),
      );
  }

  Widget _goalCard(BuildContext context, AppState state, Goal goal) {
    final colors = Theme.of(context).colorScheme;
    final color = goal.isCompleted ? colors.secondary : colors.primary;
    return Dismissible(
      key: Key(goal.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: colors.error.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(Icons.delete, color: colors.onError),
      ),
      confirmDismiss: (_) async {
        await _removeGoalWithUndo(context, state, goal);
        return false;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: goal.isCompleted
              ? colors.secondary.withValues(alpha: 0.07)
              : colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: goal.isCompleted
                ? colors.secondary.withValues(alpha: 0.4)
                : colors.outline,
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
                        goal.title,
                        style: TextStyle(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${goal.subject} · ${goal.dueDate == null ? _deadlineLabel(goal.deadline) : 'Bitiş: ${_formatDate(goal.dueDate!)}'}',
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${goal.currentCount}/${goal.targetCount} ${goal.unit}',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    IconButton(
                      tooltip: '${goal.title} hedefini sil',
                      onPressed: () =>
                          _removeGoalWithUndo(context, state, goal),
                      icon: Icon(
                        Icons.delete_outline,
                        color: colors.error,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: goal.progress,
                minHeight: 8,
                backgroundColor: colors.outline.withValues(alpha: 0.25),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
            const SizedBox(height: 8),
            if (!goal.hasValidTarget)
              Text(
                'Bu eski hedefin sayı değeri geçersiz. Kaydı silip geçerli bir hedef oluşturabilirsin.',
                style: TextStyle(color: colors.tertiary, fontSize: 12),
              )
            else
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _incrementButton(context, state, goal, -5, '-5'),
                  _incrementButton(context, state, goal, -1, '-1'),
                  _incrementButton(context, state, goal, 1, '+1'),
                  _incrementButton(context, state, goal, 5, '+5'),
                  _incrementButton(context, state, goal, 10, '+10'),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _removeGoalWithUndo(
    BuildContext context,
    AppState state,
    Goal goal,
  ) async {
    if (state.isProfileTransitioning) return;
    final index = state.goals.indexWhere(
      (savedGoal) => savedGoal.id == goal.id,
    );
    if (index < 0) return;
    final profileId = state.activeProfile.id;
    final saved = await state.removeGoal(goal.id);
    if (!context.mounted) return;
    if (!saved) {
      await showRecordResult(context, Future.value(false));
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${goal.title} silindi.'),
          action: SnackBarAction(
            label: 'Geri al',
            onPressed: () => showRecordResult(
              context,
              state.restoreGoal(goal, index: index, profileId: profileId),
            ),
          ),
        ),
      );
  }

  Widget _incrementButton(
    BuildContext context,
    AppState state,
    Goal goal,
    int amount,
    String label,
  ) {
    final colors = Theme.of(context).colorScheme;
    final action = amount < 0 ? 'azalt' : 'artır';
    final amountLabel = amount.abs();
    return SizedBox(
      width: 44,
      height: 44,
      child: Semantics(
        label: 'Hedef ilerlemesini $amountLabel ${goal.unit} $action',
        button: true,
        child: TextButton(
          onPressed: state.isSavingRecord('goals_data', goal.id)
              ? null
              : () => showRecordResult(
                  context,
                  state.updateGoalProgress(goal.id, goal.currentCount + amount),
                ),
          style: TextButton.styleFrom(
            minimumSize: const Size(44, 44),
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.padded,
            foregroundColor: amount > 0 ? colors.primary : colors.error,
            backgroundColor: (amount > 0 ? colors.primary : colors.error)
                .withValues(alpha: 0.12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  String _deadlineLabel(String deadline) => switch (deadline) {
    'bu_hafta' => 'Bu Hafta',
    'bu_ay' => 'Bu Ay',
    'sinava_kadar' => 'Sınava Kadar',
    _ => 'Özel',
  };

  String _formatDate(DateTime date) =>
      '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';

  void _showAddGoalDialog(BuildContext context, AppState state) {
    String subject = 'Genel';
    String unit = 'soru';
    final now = DateTime.now();
    DateTime dueDate = DateTime(now.year, now.month, now.day + 7);
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final targetController = TextEditingController(text: '20');
    final colors = Theme.of(context).colorScheme;

    showRetainedBottomSheet<void>(
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
          child: StatefulBuilder(
            builder: (context, setModalState) => Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎯 Yeni Hedef',
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText:
                          'Hedef başlığı (ör: Bu hafta 30 Mat sorusu çöz)',
                    ),
                    maxLength: 120,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Hedef başlığını yaz.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: targetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Hedef miktarı',
                    ),
                    validator: (value) {
                      final parsed = int.tryParse(value?.trim() ?? '');
                      if (parsed == null ||
                          parsed < 1 ||
                          parsed > Goal.maxTargetCount)
                        return '1 ile ${Goal.maxTargetCount} arasında tam sayı gir.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: unit,
                    isExpanded: true,
                    dropdownColor: colors.surface,
                    decoration: const InputDecoration(labelText: 'Birim'),
                    items: [
                      for (final value in ['soru', 'konu', 'saat', 'deneme'])
                        DropdownMenuItem(value: value, child: Text(value)),
                    ],
                    onChanged: (value) => setModalState(() => unit = value!),
                  ),
                  const SizedBox(height: 10),
                  FormField<DateTime>(
                    initialValue: dueDate,
                    validator: (value) {
                      if (value == null) return 'Hedef tarihi seç.';
                      final current = DateTime.now();
                      final today = DateTime(
                        current.year,
                        current.month,
                        current.day,
                      );
                      final selected = DateTime(
                        value.year,
                        value.month,
                        value.day,
                      );
                      if (selected.isBefore(today)) {
                        return 'Hedef tarihi bugünden önce olamaz.';
                      }
                      return null;
                    },
                    builder: (field) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () async {
                            final current = DateTime.now();
                            final today = DateTime(
                              current.year,
                              current.month,
                              current.day,
                            );
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: dueDate.isBefore(today)
                                  ? today
                                  : dueDate,
                              firstDate: today,
                              lastDate: DateTime(today.year + 5, 12, 31),
                              helpText: 'Hedefin tamamlanacağı günü seç',
                              cancelText: 'Vazgeç',
                              confirmText: 'Seç',
                            );
                            if (picked == null || !context.mounted) return;
                            final selected = DateTime(
                              picked.year,
                              picked.month,
                              picked.day,
                            );
                            setModalState(() => dueDate = selected);
                            field.didChange(selected);
                          },
                          icon: const Icon(Icons.event_outlined),
                          label: Text('Hedef tarihi: ${_formatDate(dueDate)}'),
                        ),
                        if (field.errorText != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 12, top: 4),
                            child: Text(
                              field.errorText!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() == true) {
                          submit(
                            () => state.addGoal(
                              Goal(
                                id: 'goal_${DateTime.now().millisecondsSinceEpoch}',
                                title: titleController.text,
                                subject: subject,
                                targetCount: int.parse(
                                  targetController.text.trim(),
                                ),
                                unit: unit,
                                deadline: 'ozel',
                                dueDate: dueDate,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Hedefi Kaydet'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    ).whenComplete(() {
      titleController.dispose();
      targetController.dispose();
    });
  }
}
