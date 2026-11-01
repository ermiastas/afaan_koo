import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../models/video_item.dart';
import '../../services/video_download_service.dart';
import '../../services/video_favorites_service.dart';
import '../../services/video_player_controller.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoItem video;

  final VideoDownloadService downloadService = VideoDownloadService();

  VideoPlayerScreen({
    super.key,
    required this.video,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? videoController;
  ChewieController? chewieController;
  YoutubePlayerController? youtubeController;

  bool _loading = true;
  String? _error;
  bool _isFavorite = false;
  bool _favoriteLoading = false;

  static const String _channelUrl = 'https://www.youtube.com/@AfaanKoo';

  bool get _isYouTube =>
      widget.video.source == 'youtube' &&
      widget.video.youtubeVideoId.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
    _initializeVideo();
  }

  Future<void> _loadFavorite() async {
    final service = VideoFavoritesService();
    final favorite = await service.isFavorite(widget.video.id);

    if (!mounted) return;

    setState(() {
      _isFavorite = favorite;
    });
  }

  Future<void> _toggleFavorite() async {
    if (_favoriteLoading) return;

    setState(() {
      _favoriteLoading = true;
    });

    try {
      final service = VideoFavoritesService();
      final favorite = await service.toggleFavorite(widget.video.id);

      if (!mounted) return;

      setState(() {
        _isFavorite = favorite;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            favorite
                ? 'Viidiyoon save ta' 'eera.'
                : 'Viidiyoon save keessaa baafame.',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _favoriteLoading = false;
        });
      }
    }
  }

  Future<void> _initializeVideo() async {
    try {
      if (_isYouTube) {
        youtubeController = YoutubePlayerController.fromVideoId(
          videoId: widget.video.youtubeVideoId,
          autoPlay: false,
          params: const YoutubePlayerParams(
            showControls: true,
            showFullscreenButton: true,
            mute: false,
          ),
        );

        if (mounted) {
          setState(() {
            _loading = false;
          });
        }

        return;
      }

      videoController = createVideoPlayerController(widget.video.videoUrl);

      await videoController!.initialize();

      chewieController = ChewieController(
        videoPlayerController: videoController!,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        showControls: true,
      );

      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Video player initialization error: $e');

      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Viidiyoo banuu hin dandeenye.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.video.title),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildPlayer(),
          ),
          _bottomPanel(),
        ],
      ),
    );
  }

  Widget _buildPlayer() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    if (_isYouTube && youtubeController != null) {
      return Center(
        child: YoutubePlayer(
          controller: youtubeController!,
          aspectRatio: 16 / 9,
          autoFullScreen: true,
          keepAlive: true,
        ),
      );
    }

    if (chewieController != null) {
      return Chewie(
        controller: chewieController!,
      );
    }

    return const Center(
      child: Text(
        'Viidiyoon hin argamne.',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _bottomPanel() {
    return Container(
      padding: const EdgeInsets.all(15),
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 650;

            final actions = Wrap(
              alignment: WrapAlignment.end,
              spacing: 2,
              runSpacing: 2,
              children: [
                if (!_isYouTube && widget.video.downloadable)
                  IconButton(
                    tooltip: 'Buusi',
                    icon: const Icon(Icons.download_rounded),
                    onPressed: _downloadVideo,
                  ),
                if (_isYouTube)
                  IconButton(
                    tooltip: 'Qoodi',
                    icon: const Icon(Icons.share_rounded),
                    onPressed: _shareVideo,
                  ),
                if (_isYouTube)
                  IconButton(
                    tooltip: 'Subscribe godhi',
                    icon: const Icon(Icons.subscriptions_rounded),
                    onPressed: _subscribeToChannel,
                  ),
                if (_isYouTube)
                  IconButton(
                    tooltip: 'Like godhi',
                    icon: const Icon(Icons.thumb_up_alt_rounded),
                    onPressed: _likeVideo,
                  ),
                IconButton(
                  tooltip: _isYouTube ? 'Save godhi' : 'Jaaladhu',
                  icon: Icon(
                    _isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                  ),
                  onPressed: _favoriteLoading ? null : _toggleFavorite,
                ),
              ],
            );

            final title = Row(
              children: [
                Text(
                  widget.video.emoji,
                  style: const TextStyle(fontSize: 35),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.video.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.video.rewardXP > 0)
                        Text(
                          '+${widget.video.rewardXP} XP',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );

            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  title,
                  const SizedBox(height: 6),
                  actions,
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: title),
                const SizedBox(width: 8),
                actions,
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _subscribeToChannel() async {
    final uri = Uri.parse(_channelUrl);
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> _likeVideo() async {
    final videoId = widget.video.youtubeVideoId.trim();
    if (videoId.isEmpty) return;

    final uri = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> _shareVideo() async {
    final videoId = widget.video.youtubeVideoId.trim();
    if (videoId.isEmpty) return;

    final uri = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Viidiyoo qooduu hin dandeenye.'),
        ),
      );
    }
  }

  Future<void> _downloadVideo() async {
    double progress = 0;

    final path = await widget.downloadService.downloadVideo(
      video: widget.video,
      onProgress: (value) {
        progress = value;

        if (mounted) {
          setState(() {});
        }
      },
    );

    if (!mounted) return;

    if (path != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Download ${(progress * 100).round()}% xumureera.',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Viidiyoo buusuun hin milkoofne.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    videoController?.dispose();
    chewieController?.dispose();
    youtubeController?.close();
    super.dispose();
  }
}
