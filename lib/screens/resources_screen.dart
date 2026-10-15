import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/resources_data.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  Future<void> _openResourceSearch(
    BuildContext context,
    Resource resource,
  ) async {
    final uri = Uri.https('www.youtube.com', '/results', {
      'search_query': resource.searchQuery,
    });
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened && context.mounted) {
        _showMessage(context, 'YouTube araması açılamadı; sonra tekrar dene.');
      }
    } catch (_) {
      if (context.mounted) {
        _showMessage(context, 'YouTube araması açılamadı; sonra tekrar dene.');
      }
    }
  }

  Future<void> _copyResourceSearch(
    BuildContext context,
    Resource resource,
  ) async {
    try {
      await Clipboard.setData(ClipboardData(text: resource.searchQuery));
      if (context.mounted) _showMessage(context, 'Arama ifadesi kopyalandı.');
    } catch (_) {
      if (context.mounted) {
        _showMessage(context, 'Arama ifadesi kopyalanamadı.');
      }
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final resources = getResources();
    final tactics = getExamTactics();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('💡 Kaynaklar & Taktik'),
          bottom: TabBar(
            indicatorColor: colors.primary,
            labelColor: colors.primary,
            unselectedLabelColor: colors.onSurfaceVariant,
            tabs: [
              Tab(text: 'Kaynaklar'),
              Tab(text: 'Sınav Taktikleri'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Resources
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: resources.length,
              itemBuilder: (context, index) {
                final r = resources[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colors.outline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.channel,
                                  style: textTheme.titleMedium?.copyWith(
                                    color: colors.onSurface,
                                  ),
                                ),
                                Text(
                                  r.subject,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        r.focus,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Arama: ${r.searchQuery}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilledButton.icon(
                            onPressed: () => _openResourceSearch(context, r),
                            icon: const Icon(Icons.search),
                            label: const Text('YouTube’da ara'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => _copyResourceSearch(context, r),
                            icon: const Icon(Icons.copy_outlined),
                            label: const Text('Aramayı kopyala'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            // Tactics
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tactics.length,
              itemBuilder: (context, index) {
                final t = tactics[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.outline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.title,
                        style: textTheme.titleMedium?.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t.description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
