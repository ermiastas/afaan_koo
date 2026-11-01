import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/content_pack.dart';
import '../../providers/content_pack_provider.dart';
import '../../services/content_pack_downloader.dart';

class ContentPackScreen extends StatelessWidget {
  const ContentPackScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContentPackProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Qabiyyee Barnootaa'),
      ),
      body: provider.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : provider.packs.isEmpty
              ? _EmptyState(
                  message: provider.hasError
                      ? 'Qabiyyeen barnootaa argamuu hin dandeenye.'
                      : 'Qabiyyeen barnootaa ammaaf hin jiru.',
                )
              : RefreshIndicator(
                  onRefresh: provider.load,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.packs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final pack = provider.packs[index];

                      return _ContentPackCard(
                        pack: pack,
                      );
                    },
                  ),
                ),
    );
  }
}

class _ContentPackCard extends StatelessWidget {
  const _ContentPackCard({
    required this.pack,
  });

  final ContentPack pack;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContentPackProvider>();
    final status = provider.statusFor(pack.id);
    final progress = provider.progressFor(pack.id);

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Content Packs',
                    style: TextStyle(fontSize: 32),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pack.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pack.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: const Icon(
                    Icons.menu_book_outlined,
                    size: 18,
                  ),
                  label: Text(
                    '${pack.lessonCount} barnoota',
                  ),
                ),
                Chip(
                  avatar: const Icon(
                    Icons.category_outlined,
                    size: 18,
                  ),
                  label: Text(pack.category),
                ),
                Chip(
                  avatar: const Icon(
                    Icons.info_outline,
                    size: 18,
                  ),
                  label: Text('v${pack.version}'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _StatusView(
              status: status,
              progress: progress,
            ),
            const SizedBox(height: 12),
            _ActionButtons(
              pack: pack,
              status: status,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusView extends StatelessWidget {
  const _StatusView({
    required this.status,
    required this.progress,
  });

  final ContentPackInstallationStatus status;
  final ContentPackDownloadProgress? progress;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ContentPackInstallationStatus.notInstalled:
        return const Text(
          'Pakkii kun meesha kana irratti hin buufamne.',
        );

      case ContentPackInstallationStatus.downloading:
        final fraction = progress?.fraction;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Buufamaa jira...',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: fraction,
            ),
            if (progress != null) ...[
              const SizedBox(height: 6),
              Text(
                _progressText(progress!),
              ),
            ],
          ],
        );

      case ContentPackInstallationStatus.installing:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Qabiyyeen barnootaa fe\'amaa jira...',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(),
          ],
        );

      case ContentPackInstallationStatus.installed:
        return const Row(
          children: [
            Icon(
              Icons.check_circle,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Qophaa\'eera \'-- offline fayyadamuun ni danda\'ama.',
            ),
          ],
        );

      case ContentPackInstallationStatus.updateAvailable:
        return const Row(
          children: [
            Icon(
              Icons.system_update_alt,
              size: 20,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Fooyya\'iinsi haaraan jira.',
              ),
            ),
          ],
        );

      case ContentPackInstallationStatus.failed:
        return const Row(
          children: [
            Icon(
              Icons.error_outline,
              size: 20,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Buufachuu ykn fe\'uu hin dandeenye. Irra deebi\'i.',
              ),
            ),
          ],
        );
    }
  }

  String _progressText(
    ContentPackDownloadProgress progress,
  ) {
    if (progress.totalBytes <= 0) {
      return '${_formatBytes(progress.receivedBytes)} buufamaa jira';
    }

    final percent = ((progress.fraction ?? 0) * 100).round();

    return '$percent% â€¢ '
        '${_formatBytes(progress.receivedBytes)} / '
        '${_formatBytes(progress.totalBytes)}';
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }

    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }

    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.pack,
    required this.status,
  });

  final ContentPack pack;
  final ContentPackInstallationStatus status;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ContentPackProvider>();

    switch (status) {
      case ContentPackInstallationStatus.notInstalled:
        return SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => _download(
              context,
              provider,
            ),
            icon: const Icon(Icons.download),
            label: const Text('Buufadhu'),
          ),
        );

      case ContentPackInstallationStatus.downloading:
      case ContentPackInstallationStatus.installing:
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: null,
            icon: const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
            label: const Text('Hojii irra jira...'),
          ),
        );

      case ContentPackInstallationStatus.installed:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _remove(
                  context,
                  provider,
                ),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Haqi'),
              ),
            ),
          ],
        );

      case ContentPackInstallationStatus.updateAvailable:
        return Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => _update(
                  context,
                  provider,
                ),
                icon: const Icon(
                  Icons.system_update_alt,
                ),
                label: const Text('Fooyyeessi'),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Haqi',
              onPressed: () => _remove(
                context,
                provider,
              ),
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        );

      case ContentPackInstallationStatus.failed:
        return SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => _retry(
              context,
              provider,
            ),
            icon: const Icon(Icons.refresh),
            label: const Text('Irra deebi\'i'),
          ),
        );
    }
  }

  Future<void> _download(
    BuildContext context,
    ContentPackProvider provider,
  ) async {
    await _run(
      context,
      () => provider.download(pack.id),
    );
  }

  Future<void> _update(
    BuildContext context,
    ContentPackProvider provider,
  ) async {
    await _run(
      context,
      () => provider.update(pack.id),
    );
  }

  Future<void> _retry(
    BuildContext context,
    ContentPackProvider provider,
  ) async {
    await _run(
      context,
      () => provider.retry(pack.id),
    );
  }

  Future<void> _remove(
    BuildContext context,
    ContentPackProvider provider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Pakkii haqii?',
          ),
          content: Text(
            '"${pack.title}" meesha kana irraa ni haqama. '
            'Progress barnootaa kee hin haqamu.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Lakki'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eeyyee, haqi'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await _run(
      context,
      () => provider.remove(pack.id),
    );
  }

  Future<void> _run(
    BuildContext context,
    Future<void> Function() operation,
  ) async {
    try {
      await operation();
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
          ),
        ),
      );
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Content Packs',
              style: TextStyle(
                fontSize: 64,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
