import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/video_catalog_provider.dart';
import '../../utils/responsive.dart';
import '../../widgets/tv/video_card.dart';
import 'video_player_screen.dart';

/// A name-driven video library. There are no preset categories: each video an
/// administrator enters is shown using its own title or a title inferred from
/// the source file name.
class AfaanKooTVHomeScreen extends StatefulWidget {
  const AfaanKooTVHomeScreen({super.key});

  @override
  State<AfaanKooTVHomeScreen> createState() => _AfaanKooTVHomeScreenState();
}

class _AfaanKooTVHomeScreenState extends State<AfaanKooTVHomeScreen> {
  String _search = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<VideoCatalogProvider>().load();
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
            tooltip: 'Refresh video library',
            onPressed: catalog.isLoading ? null : catalog.load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: catalog.isLoading && catalog.videos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    Responsive.pagePadding(context),
                    16,
                    Responsive.pagePadding(context),
                    8,
                  ),
                  sliver: SliverToBoxAdapter(child: _header(videos.length)),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.pagePadding(context),
                  ),
                  sliver: SliverToBoxAdapter(child: _searchBox()),
                ),
                if (videos.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _emptyLibrary(),
                  )
                else
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
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => VideoPlayerScreen(video: video),
                              ),
                            ),
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

  Widget _header(int count) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.ondemand_video_rounded,
                  color: Color(0xff5C4DB1), size: 38),
              const SizedBox(width: 10),
              Text('AfaanKoo TV+',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      )),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$count viidiyoo maqaan isaanii irratti hundaa\'ee tarreeffaman',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );

  Widget _searchBox() => TextField(
        onChanged: (value) => setState(() => _search = value),
        decoration: const InputDecoration(
          hintText: 'Maqaa viidiyoo barbaadi',
          prefixIcon: Icon(Icons.search_rounded),
        ),
      );

  Widget _emptyLibrary() => Center(
        child: Padding(
          padding: EdgeInsets.all(Responsive.pagePadding(context)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.video_library_outlined,
                  size: 72, color: Color(0xff5C4DB1)),
              const SizedBox(height: 16),
              Text('Viidiyoon mootummaa hin galchine',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              const SizedBox(height: 8),
              const Text(
                'Admin Dashboard keessaa Videos filadhu; maqaa fi linkii ykn faayila viidiyoo galchi.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}
