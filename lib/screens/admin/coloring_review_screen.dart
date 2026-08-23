import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../models/educational_image_asset.dart';
import '../../providers/coloring_catalog_provider.dart';

/// Adult-only review queue for uncertain conversions. It is intentionally
/// separate from the child-facing colouring library.
class ColoringReviewScreen extends StatefulWidget {
  const ColoringReviewScreen({super.key});

  @override
  State<ColoringReviewScreen> createState() => _ColoringReviewScreenState();
}

class _ColoringReviewScreenState extends State<ColoringReviewScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() => context
        .read<ColoringCatalogProvider>()
        .initialize(initialConversionBudget: 0));
  }

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<ColoringCatalogProvider>();
    final queue = catalog.pendingReview;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coloring review'),
        actions: [
          IconButton(
            tooltip: 'Process next assets',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => catalog.processNextBatch(maximum: 8),
          ),
        ],
      ),
      body: queue.isEmpty
          ? const Center(child: Text('No colouring pages need review.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: queue.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) => _reviewCard(context, queue[index]),
            ),
    );
  }

  Widget _reviewCard(BuildContext context, EducationalImageAsset asset) {
    final catalog = context.read<ColoringCatalogProvider>();
    final svg = catalog.svgForPage(asset.id);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(asset.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(
                '${asset.category ?? 'Other'} • ${(asset.conversionConfidence * 100).round()}%'),
            Text(asset.candidateReason ?? '',
                style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: Row(
                children: [
                  Expanded(
                    child: asset.sourcePath.isEmpty
                        ? const Center(child: Text('Remote original'))
                        : Image.asset(asset.sourcePath, fit: BoxFit.contain),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    child: svg == null
                        ? const Center(child: Text('No safe SVG preview'))
                        : SvgPicture.string(svg, fit: BoxFit.contain),
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: 8,
              children: [
                FilledButton.icon(
                  onPressed:
                      svg == null ? null : () => catalog.approve(asset.id),
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Approve'),
                ),
                OutlinedButton.icon(
                  onPressed: () => catalog.retry(asset.id),
                  icon: const Icon(Icons.autorenew_rounded),
                  label: const Text('Re-vectorize'),
                ),
                TextButton.icon(
                  onPressed: () => catalog.reject(asset.id),
                  icon: const Icon(Icons.close_rounded),
                  label: const Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
