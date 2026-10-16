import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/weak_topic.dart';
import '../providers/app_state.dart';

class WeakTopicsScreen extends StatelessWidget {
  const WeakTopicsScreen({super.key});

  // YouTube search links by subject
  static String _getYoutubeLink(String subject, String topic) {
    final query = Uri.encodeComponent('$subject $topic YKS konu anlatimi');
    return 'https://www.youtube.com/results?search_query=$query';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final colors = Theme.of(context).colorScheme;
        final today = DateTime.now();
        final dueReviews = state.weakTopics
            .where(
              (topic) =>
                  topic.isStudied &&
                  (topic.needsRepeat || topic.isReviewDueOn(today)),
            )
            .toList();
        final active = state.weakTopics.where((t) => !t.isStudied).toList();
        final dueIds = dueReviews.map((topic) => topic.id).toSet();
        final studied = state.weakTopics
            .where((t) => t.isStudied && !dueIds.contains(t.id))
            .toList();

        return Scaffold(
          appBar: AppBar(title: const Text('Zayıf Konularım')),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddDialog(context, state),
            icon: const Icon(Icons.add),
            label: const Text('Ekle'),
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
          ),
          body: state.weakTopics.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Henüz zayıf konu eklenmedi',
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Deneme veya soru çözerken hata yaptığın\nkonuları buraya ekle.',
                        textAlign: TextAlign.center,
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
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colors.tertiaryContainer.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colors.tertiary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        '“Çalışıldı” ilk tekrarı 1 gün sonrasına alır. “Tekrar ettim” aralıkları 3 günden başlayarak en fazla 30 güne çıkarır. Bu yerel çalışma önerisidir; bildirim göndermez ve öğrenme garantisi vermez.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurface,
                          height: 1.4,
                        ),
                      ),
                    ),
                    if (dueReviews.isNotEmpty) ...[
                      Text(
                        'Tekrar zamanı (${dueReviews.length})',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),
                      ...dueReviews.map((t) => _topicCard(context, state, t)),
                    ],
                    if (active.isNotEmpty) ...[
                      Text(
                        'Çalışılacak (${active.length})',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),
                      ...active.map((t) => _topicCard(context, state, t)),
                    ],
                    if (studied.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        'Çalışıldı (${studied.length})',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),
                      ...studied.map((t) => _topicCard(context, state, t)),
                    ],
                  ],
                ),
        );
      },
    );
  }

  Widget _topicCard(BuildContext context, AppState state, WeakTopic topic) {
    final colors = Theme.of(context).colorScheme;
    final dueReview =
        topic.isStudied &&
        (topic.needsRepeat || topic.isReviewDueOn(DateTime.now()));
    return Dismissible(
      key: Key(topic.id),
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
      onDismissed: (_) => _removeTopicWithUndo(context, state, topic),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: topic.isStudied
              ? colors.secondary.withValues(alpha: 0.07)
              : colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: topic.isStudied
                ? colors.secondary.withValues(alpha: 0.4)
                : colors.error.withValues(alpha: 0.3),
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
                        topic.topic,
                        style: TextStyle(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${topic.subject} - ${topic.date}',
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: colors.error.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${topic.errorCount}x hata',
                    style: TextStyle(
                      color: colors.error,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: '${topic.topic} zayıf konu kaydını sil',
                  onPressed: () => _removeTopicWithUndo(context, state, topic),
                  icon: Icon(
                    Icons.delete_outline,
                    color: colors.error,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Hata: ${topic.errorType}',
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
            ),
            Text(
              'Yapılacak: ${topic.action}',
              style: TextStyle(color: colors.tertiary, fontSize: 12),
            ),
            if (topic.nextReviewAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _reviewStatus(topic, dueReview),
                  style: TextStyle(
                    color: dueReview
                        ? colors.tertiary
                        : colors.onSurfaceVariant,
                    fontSize: 11,
                    fontWeight: dueReview ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            const SizedBox(height: 10),

            // A real button keeps this action available to keyboard and
            // screen-reader users, with a visible failure message if opening
            // the external search is not supported.
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => _openYoutubeSearch(context, topic),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  foregroundColor: colors.error,
                  backgroundColor: colors.error.withValues(alpha: 0.08),
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: colors.error.withValues(alpha: 0.25),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.play_arrow, color: colors.error),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'YouTube’da ara',
                            style: TextStyle(
                              color: colors.error,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${topic.subject} - ${topic.topic}',
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.open_in_new,
                      color: colors.onSurfaceVariant,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: dueReview
                        ? () => state.completeWeakTopicReview(topic.id)
                        : () => state.toggleWeakTopicStudied(topic.id),
                    icon: Icon(
                      dueReview
                          ? Icons.replay_rounded
                          : topic.isStudied
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      size: 16,
                    ),
                    label: Text(
                      dueReview
                          ? 'Tekrar ettim'
                          : topic.isStudied
                          ? 'Çalışıldı'
                          : 'Çalış',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: dueReview
                          ? colors.tertiary
                          : topic.isStudied
                          ? colors.secondary
                          : colors.onSurfaceVariant,
                      side: BorderSide(
                        color: dueReview
                            ? colors.tertiary
                            : topic.isStudied
                            ? colors.secondary
                            : colors.outline,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => state.toggleWeakTopicRepeat(topic.id),
                    icon: Icon(
                      topic.needsRepeat ? Icons.replay : Icons.replay_outlined,
                      size: 16,
                    ),
                    label: Text(topic.needsRepeat ? 'Tekrar Gerek' : 'Tekrar?'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: topic.needsRepeat
                          ? colors.tertiary
                          : colors.onSurfaceVariant,
                      side: BorderSide(
                        color: topic.needsRepeat
                            ? colors.tertiary
                            : colors.outline,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _reviewStatus(WeakTopic topic, bool dueReview) {
    final last = topic.lastReviewedAt?.toLocal();
    final next = topic.nextReviewAt?.toLocal();
    final lastText = last == null ? null : _formatDate(last);
    if (dueReview) {
      return lastText == null
          ? 'Önceki çalışma kaydından sonra tekrar zamanı geldi.'
          : 'Son çalışma: $lastText · Tekrar zamanı geldi.';
    }
    return 'Son çalışma: $lastText · Sonraki tekrar: ${_formatDate(next!)}';
  }

  String _formatDate(DateTime date) =>
      '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';

  void _removeTopicWithUndo(
    BuildContext context,
    AppState state,
    WeakTopic topic,
  ) {
    if (state.isProfileTransitioning) return;
    final index = state.weakTopics.indexWhere(
      (savedTopic) => savedTopic.id == topic.id,
    );
    if (index < 0) return;
    final profileId = state.activeProfile.id;
    state.removeWeakTopic(topic.id);
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${topic.topic} silindi.'),
          action: SnackBarAction(
            label: 'Geri al',
            onPressed: () => state.restoreWeakTopic(
              topic,
              index: index,
              profileId: profileId,
            ),
          ),
        ),
      );
  }

  Future<void> _openYoutubeSearch(BuildContext context, WeakTopic topic) async {
    final uri = Uri.parse(_getYoutubeLink(topic.subject, topic.topic));
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('YouTube araması açılamadı; sonra tekrar dene.'),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('YouTube araması açılamadı; sonra tekrar dene.'),
          ),
        );
      }
    }
  }

  void _showAddDialog(BuildContext context, AppState state) {
    final colors = Theme.of(context).colorScheme;
    final subjects = List.of(state.subjects);
    if (subjects.isEmpty) return;

    var selectedSubject = subjects.firstWhere(
      (item) => item.name == 'TYT Matematik',
      orElse: () => subjects.first,
    );
    String topic = '';
    String? selectedTopicId;
    String? topicError;
    String errorType = '';
    int errorCount = 1;
    String action = '';
    const manualTopicId = '__manual_topic__';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 20,
        ),
        child: StatefulBuilder(
          builder: (context, setModalState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Zayıf konu ekle',
                style: TextStyle(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedSubject.storageId,
                dropdownColor: colors.surface,
                decoration: const InputDecoration(labelText: 'Ders'),
                items: subjects
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.storageId,
                        child: Text(
                          item.name,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setModalState(() {
                    selectedSubject = subjects.firstWhere(
                      (item) => item.storageId == value,
                    );
                    selectedTopicId = null;
                    topic = '';
                    topicError = null;
                  });
                },
              ),
              const SizedBox(height: 10),
              if (selectedSubject.topics.isNotEmpty)
                DropdownButtonFormField<String>(
                  key: ValueKey(selectedSubject.storageId),
                  initialValue: selectedTopicId,
                  dropdownColor: colors.surface,
                  decoration: InputDecoration(
                    labelText: 'Konu',
                    hintText: 'Müfredattan konu seç',
                    errorText: topicError,
                  ),
                  items: [
                    ...selectedSubject.topics.map(
                      (item) => DropdownMenuItem(
                        value: item.id,
                        child: Text(
                          item.name,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    const DropdownMenuItem(
                      value: manualTopicId,
                      child: Text('Listede yok, kendim yazacağım'),
                    ),
                  ],
                  onChanged: (value) {
                    setModalState(() {
                      selectedTopicId = value;
                      topicError = null;
                      if (value == manualTopicId) {
                        topic = '';
                      } else if (value != null) {
                        topic = selectedSubject.topics
                            .firstWhere((item) => item.id == value)
                            .name;
                      }
                    });
                  },
                ),
              if (selectedSubject.topics.isEmpty ||
                  selectedTopicId == manualTopicId) ...[
                if (selectedSubject.topics.isNotEmpty)
                  const SizedBox(height: 10),
                TextField(
                  key: ValueKey('manual_topic_${selectedSubject.storageId}'),
                  decoration: InputDecoration(
                    labelText: 'Konu',
                    hintText: 'Konu adını yaz',
                    errorText: topicError,
                  ),
                  onChanged: (value) {
                    topic = value;
                    if (topicError != null) {
                      setModalState(() => topicError = null);
                    }
                  },
                ),
              ],
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: 'Hata türü'),
                onChanged: (v) => errorType = v,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: 'Ne yapacaksın?'),
                onChanged: (v) => action = v,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final normalizedTopic = topic.trim();
                    if (normalizedTopic.isEmpty) {
                      setModalState(
                        () => topicError = 'Bir konu seç veya konu adını yaz.',
                      );
                      return;
                    }
                    final now = DateTime.now();
                    state.addWeakTopic(
                      WeakTopic(
                        id: 'wt_${now.microsecondsSinceEpoch}',
                        date:
                            '${now.day}.${now.month.toString().padLeft(2, '0')}.${now.year}',
                        subject: selectedSubject.name,
                        subjectId: selectedSubject.storageId,
                        topic: normalizedTopic,
                        topicId: selectedTopicId == manualTopicId
                            ? null
                            : selectedTopicId,
                        errorType: errorType.trim(),
                        errorCount: errorCount,
                        action: action.trim(),
                      ),
                    );
                    Navigator.pop(context);
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
  }
}
