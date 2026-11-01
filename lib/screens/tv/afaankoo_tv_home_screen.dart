import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/video_catalog_provider.dart';
import '../../utils/responsive.dart';
import '../../widgets/tv/video_card.dart';
import 'video_player_screen.dart';

class AfaanKooTVHomeScreen extends StatefulWidget {
  const AfaanKooTVHomeScreen({super.key});

  @override
  State<AfaanKooTVHomeScreen> createState() => _AfaanKooTVHomeScreenState();
}

class _AfaanKooTVHomeScreenState extends State<AfaanKooTVHomeScreen> {
  static final Uri _channelUri = Uri.parse('https://www.youtube.com/@AfaanKoo');

  String _search = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<VideoCatalogProvider>().load();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<VideoCatalogProvider>();
    final query = _search.trim().toLowerCase();

    final videos = catalog.videos.where((video) {
      if (query.isEmpty) return true;

      return video.title.toLowerCase().contains(query) ||
          video.titleEnglish.toLowerCase().contains(query) ||
          video.description.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xffEAF7FF),
      appBar: AppBar(
        title: const Text('AfaanKoo TV+'),
        actions: [
          IconButton(
            tooltip: 'Irra deebi\'i',
            onPressed: catalog.isLoading ? null : catalog.load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: catalog.isLoading && catalog.videos.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    Responsive.pagePadding(context),
                    16,
                    Responsive.pagePadding(context),
                    8,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _header(
                      context,
                      videos.length,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.pagePadding(context),
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _channelBanner(context),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    Responsive.pagePadding(context),
                    12,
                    Responsive.pagePadding(context),
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _searchBox(),
                  ),
                ),
                if (catalog.error != null)
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      Responsive.pagePadding(context),
                      16,
                      Responsive.pagePadding(context),
                      0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _errorCard(
                        catalog.error!,
                        catalog.load,
                      ),
                    ),
                  ),
                if (videos.isEmpty && catalog.error == null)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _emptyLibrary(),
                  )
                else if (videos.isNotEmpty)
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      Responsive.pagePadding(context),
                      20,
                      Responsive.pagePadding(context),
                      104,
                    ),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final video = videos[index];

                          return VideoCard(
                            video: video,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => VideoPlayerScreen(
                                    video: video,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        childCount: videos.length,
                      ),
                      gridDelegate: Responsive.homeGridDelegate(
                        context,
                        childAspectRatio: .76,
                        maxColumns: 5,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _header(BuildContext context, int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xff5C4DB1),
                borderRadius: BorderRadius.circular(17),
              ),
              child: const Icon(
                Icons.ondemand_video_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'AfaanKoo TV+',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '$count viidiyoo Afaan Koo YouTube channel irraa.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _channelBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffE5DFFF)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 430;

          final channelIcon = Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_circle_fill_rounded,
              color: Colors.red,
              size: 34,
            ),
          );

          final channelText = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Afaan Koo YouTube Channel',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Viidiyoo AfaanKoo qofa ilaali, channelicha hordofi.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                ),
              ),
            ],
          );

          final subscribeButton = FilledButton.icon(
            onPressed: _openYouTubeChannel,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
            icon: const Icon(
              Icons.notifications_active_rounded,
              size: 19,
            ),
            label: const Text(
              'Subscribe',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    channelIcon,
                    const SizedBox(width: 12),
                    Expanded(child: channelText),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: subscribeButton,
                ),
              ],
            );
          }

          return Row(
            children: [
              channelIcon,
              const SizedBox(width: 12),
              Expanded(child: channelText),
              const SizedBox(width: 10),
              subscribeButton,
            ],
          );
        },
      ),
    );
  }

  Widget _searchBox() {
    return TextField(
      onChanged: (value) {
        setState(() {
          _search = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Maqaa viidiyoo barbaadi',
        prefixIcon: const Icon(
          Icons.search_rounded,
        ),
        suffixIcon: _search.isEmpty
            ? null
            : IconButton(
                tooltip: 'Qulqulleessi',
                onPressed: () {
                  setState(() {
                    _search = '';
                  });
                },
                icon: const Icon(
                  Icons.clear_rounded,
                ),
              ),
      ),
    );
  }

  Widget _errorCard(
    String message,
    Future<void> Function() retry,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.red.shade100,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.cloud_off_rounded,
            color: Colors.red.shade700,
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.red.shade900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Irra yaali',
            onPressed: retry,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyLibrary() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          Responsive.pagePadding(context),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.ondemand_video_rounded,
              size: 72,
              color: Color(0xff5C4DB1),
            ),
            const SizedBox(height: 16),
            Text(
              'Ammaaf viidiyoon hin jiru.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Viidiyoo haaraa Afaan Koo YouTube channel irratti yeroo maxxanfamu TV+ keessatti ni mul\'ata.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _openYouTubeChannel,
              icon: const Icon(
                Icons.open_in_new_rounded,
              ),
              label: const Text(
                'Afaan Koo Channel Daawwadhu',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openYouTubeChannel() async {
    try {
      final opened = await launchUrl(
        _channelUri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'YouTube channel banuun hin danda\'amne.',
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('YouTube channel launch error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'YouTube channel banuun hin danda\'amne.',
          ),
        ),
      );
    }
  }
}
