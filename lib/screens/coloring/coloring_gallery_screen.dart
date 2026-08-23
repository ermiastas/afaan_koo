import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart';

import '../../models/coloring_artwork.dart';
import '../../providers/coloring_catalog_provider.dart';
import '../../services/svg_color_engine.dart';
import '../../utils/responsive.dart';

class ColoringGalleryScreen extends StatelessWidget {
  const ColoringGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final artworks = context.watch<ColoringCatalogProvider>().artworks;
    return Scaffold(
      backgroundColor: const Color(0xffEAF7FF),
      appBar: AppBar(title: const Text('🎨 Suuraawwan Koo')),
      body: artworks.isEmpty
          ? const Center(child: Text('Suuraa kuufame hin jiru.'))
          : GridView.builder(
              padding: EdgeInsets.all(Responsive.pagePadding(context)),
              itemCount: artworks.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.homeColumns(context, max: 5),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: .78,
              ),
              itemBuilder: (_, index) => _artworkCard(context, artworks[index]),
            ),
    );
  }

  Widget _artworkCard(BuildContext context, ColoringArtwork artwork) => InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ColoringReplayScreen(artwork: artwork),
        )),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Color(0x16000000), blurRadius: 8)
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                    child: SvgPicture.string(artwork.svgMarkup,
                        fit: BoxFit.contain)),
                Text(artwork.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${artwork.colorsUsed.length} halluu',
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      tooltip: 'Rename',
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _rename(context, artwork),
                    ),
                    IconButton(
                      tooltip: 'Export',
                      icon: const Icon(Icons.ios_share_rounded),
                      onPressed: () => _export(context, artwork),
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => context
                          .read<ColoringCatalogProvider>()
                          .deleteArtwork(artwork.id),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Future<void> _rename(BuildContext context, ColoringArtwork artwork) async {
    final controller = TextEditingController(text: artwork.title);
    final title = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Maqaa jijjiiri'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Dhiisi')),
          FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Kuusi')),
        ],
      ),
    );
    controller.dispose();
    if (title != null && context.mounted) {
      await context
          .read<ColoringCatalogProvider>()
          .renameArtwork(artwork.id, title);
    }
  }

  Future<void> _export(BuildContext context, ColoringArtwork artwork) async {
    final export = artwork.imagePath ?? artwork.svgMarkup;
    await Clipboard.setData(ClipboardData(text: export));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Export path copied. You can share the saved artwork from your device.')),
      );
    }
  }
}

class ColoringReplayScreen extends StatefulWidget {
  const ColoringReplayScreen({super.key, required this.artwork});

  final ColoringArtwork artwork;

  @override
  State<ColoringReplayScreen> createState() => _ColoringReplayScreenState();
}

class _ColoringReplayScreenState extends State<ColoringReplayScreen> {
  final SvgColorEngine _engine = SvgColorEngine();
  Timer? _timer;
  late String _baseSvg;
  late String _svg;
  var _step = 0;
  var _playing = false;

  @override
  void initState() {
    super.initState();
    _baseSvg = _blankSvg(widget.artwork.svgMarkup);
    _svg = _baseSvg;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('▶ $widget.artwork.title')),
        body: Column(
          children: [
            Expanded(
                child: Center(
                    child: SvgPicture.string(_svg, fit: BoxFit.contain))),
            Text('$_step/${widget.artwork.actions.length}'),
            Slider(
              value: _step.toDouble(),
              min: 0,
              max: widget.artwork.actions.length.toDouble(),
              divisions: widget.artwork.actions.isEmpty
                  ? null
                  : widget.artwork.actions.length,
              onChanged: (value) => _seek(value.round()),
            ),
            SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      tooltip: 'Restart',
                      onPressed: () => _seek(0),
                      icon: const Icon(Icons.restart_alt_rounded)),
                  FilledButton.icon(
                    onPressed: _playing ? _pause : _play,
                    icon: Icon(_playing
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded),
                    label: Text(_playing ? 'Dhaabi' : 'Ilaali'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  void _play() {
    if (widget.artwork.actions.isEmpty) return;
    if (_step >= widget.artwork.actions.length) _seek(0);
    setState(() => _playing = true);
    _timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      if (_step >= widget.artwork.actions.length) {
        _pause();
      } else {
        _seek(_step + 1, notify: false);
        if (mounted) setState(() {});
      }
    });
  }

  void _pause() {
    _timer?.cancel();
    if (mounted) setState(() => _playing = false);
  }

  void _seek(int target, {bool notify = true}) {
    target = target.clamp(0, widget.artwork.actions.length).toInt();
    final colors = <String, String>{};
    for (final action in widget.artwork.actions.take(target)) {
      if (action.regionId == '*') {
        colors.clear();
      } else if (action.colorValue != null) {
        colors[action.regionId] =
            '#${action.colorValue!.toRadixString(16).substring(2).padLeft(6, '0').toUpperCase()}';
      }
    }
    _step = target;
    _svg = _engine.recolorMarkup(svg: _baseSvg, colors: colors);
    if (notify && mounted) setState(() {});
  }

  String _blankSvg(String svg) {
    final document = XmlDocument.parse(svg);
    for (final path in document.findAllElements('path')) {
      path.setAttribute('fill', '#FFFFFF');
    }
    return document.toXmlString();
  }
}
