import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../models/coloring_page.dart';
import '../../providers/coloring_catalog_provider.dart';
import '../../providers/reward_provider.dart';
import '../../repositories/lesson_repository.dart';
import '../../widgets/coloring/interactive_svg_coloring.dart';
import '../../widgets/coloring/coloring_frame.dart';
import 'coloring_gallery_screen.dart';

class ColoringCanvasScreen extends StatefulWidget {
  const ColoringCanvasScreen({super.key, required this.page});

  final ColoringPage page;

  @override
  State<ColoringCanvasScreen> createState() => _ColoringCanvasScreenState();
}

class _ColoringCanvasScreenState extends State<ColoringCanvasScreen> {
  final GlobalKey<InteractiveSvgColoringState> _canvasKey = GlobalKey();
  final GlobalKey _captureKey = GlobalKey();
  final Stopwatch _timer = Stopwatch();
  Color _selectedColor = Colors.red;
  ColoringSession? _session;
  bool _eraser = false;
  bool _saving = false;
  bool _rewardShown = false;
  String? _sticker;
  Offset? _stickerPosition;

  static const _palette = <Color>[
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.black,
    Colors.white,
  ];

  @override
  void initState() {
    super.initState();
    _timer.start();
  }

  @override
  void dispose() {
    _timer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final svg = widget.page.svgMarkup;
    if (svg == null || svg.isEmpty) return _legacyFallback();
    final activeColor = _eraser ? Colors.white : _selectedColor;
    return Scaffold(
      backgroundColor: const Color(0xffEAF7FF),
      appBar: AppBar(
        title: Text('${widget.page.emoji} ${widget.page.titleOromo}'),
        actions: [
          IconButton(
            tooltip: 'Replay',
            onPressed: () => _canvasKey.currentState?.replay(),
            icon: const Icon(Icons.replay_rounded),
          ),
          IconButton(
            tooltip: 'Save artwork',
            onPressed: _saving ? null : _save,
            icon: Icon(
                _saving ? Icons.hourglass_top_rounded : Icons.save_alt_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (widget.page.lessonTitle != null) _lessonLink(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: ColoringFrame(
                  child: RepaintBoundary(
                  key: _captureKey,
                  child: LayoutBuilder(
                    builder: (context, constraints) => Stack(
                      children: [
                        InteractiveSvgColoring(
                          key: _canvasKey,
                          pageId: widget.page.id,
                          svgMarkup: svg,
                          selectedColor: activeColor,
                          onChanged: (session) => _session = session,
                          onCompleted: _complete,
                        ),
                        if (_sticker != null && _stickerPosition != null)
                          Positioned(
                            left: _stickerPosition!.dx - 22,
                            top: _stickerPosition!.dy - 22,
                            child: GestureDetector(
                              onPanUpdate: (details) => setState(() {
                                final candidate =
                                    _stickerPosition! + details.delta;
                                _stickerPosition = Offset(
                                  candidate.dx
                                      .clamp(0.0, constraints.maxWidth - 44)
                                      .toDouble(),
                                  candidate.dy
                                      .clamp(0.0, constraints.maxHeight - 44)
                                      .toDouble(),
                                );
                              }),
                              child: Text(_sticker!,
                                  style: const TextStyle(fontSize: 44)),
                            ),
                          ),
                      ],
                    ),
                  ),
                  ),
                ),
              ),
            ),
            _palettePicker(),
            _toolbar(),
          ],
        ),
      ),
    );
  }

  Widget _lessonLink(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: OutlinedButton.icon(
          onPressed: () {
            final lesson =
                LessonRepository().getLessonById(widget.page.lessonId ?? '');
            if (lesson != null) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => lesson.screen));
            }
          },
          icon: const Icon(Icons.menu_book_rounded),
          label: Text('Barnoota kana ilaali • ${widget.page.lessonTitle}'),
        ),
      );

  Widget _palettePicker() => SizedBox(
        height: 62,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          scrollDirection: Axis.horizontal,
          children: _palette.map((color) {
            final selected =
                !_eraser && color.toARGB32() == _selectedColor.toARGB32();
            return Semantics(
              button: true,
              selected: selected,
              label: 'Choose colour',
              child: GestureDetector(
                onTap: () => setState(() {
                  _selectedColor = color;
                  _eraser = false;
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.all(8),
                  width: 46,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? Colors.deepOrange : Colors.white,
                      width: selected ? 4 : 2,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );

  Widget _toolbar() => Material(
        color: Colors.white,
        child: SafeArea(
          top: false,
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              _tool(Icons.format_color_fill_rounded, 'Fill',
                  () => setState(() => _eraser = false)),
              _tool(Icons.cleaning_services_rounded, 'Eraser',
                  () => setState(() => _eraser = true),
                  active: _eraser),
              _tool(Icons.undo_rounded, 'Undo',
                  () => _canvasKey.currentState?.undo(),
                  enabled: _canvasKey.currentState?.canUndo ?? false),
              _tool(Icons.redo_rounded, 'Redo',
                  () => _canvasKey.currentState?.redo(),
                  enabled: _canvasKey.currentState?.canRedo ?? false),
              _tool(Icons.delete_outline_rounded, 'Clear',
                  () => _canvasKey.currentState?.clear()),
              _tool(Icons.replay_rounded, 'Replay',
                  () => _canvasKey.currentState?.replay()),
              _tool(Icons.emoji_emotions_outlined, 'Stickers',
                  _showStickerPicker),
              _tool(Icons.photo_library_outlined, 'Gallery', () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const ColoringGalleryScreen()));
              }),
            ],
          ),
        ),
      );

  Widget _tool(IconData icon, String label, VoidCallback onPressed,
          {bool active = false, bool enabled = true}) =>
      Semantics(
        button: true,
        label: label,
        child: IconButton(
          tooltip: label,
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          onPressed: enabled ? onPressed : null,
          icon: Icon(icon),
          color: active ? Colors.deepOrange : null,
        ),
      );

  Future<void> _complete() async {
    if (_rewardShown) return;
    _rewardShown = true;
    await context
        .read<RewardProvider>()
        .completeColoringPage(pageId: widget.page.id);
    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('🎉 Baay’ee bareedaa!'),
        content: const Text('+10 XP • +5 Coins'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Galatoomi'))
        ],
      ),
    );
  }

  void _showStickerPicker() {
    const stickers = ['⭐', '🌈', '❤️', '✨', '🦋'];
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: stickers
                .map((sticker) => IconButton(
                      tooltip: sticker,
                      iconSize: 34,
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        setState(() {
                          _sticker = sticker;
                          _stickerPosition = const Offset(180, 180);
                        });
                      },
                      icon: Text(sticker),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final session = _session ?? _canvasKey.currentState?.session;
    if (session == null || session.svgMarkup.isEmpty) return;
    setState(() => _saving = true);
    try {
      final preview = await _capturePreview();
      if (!mounted) return;
      await context.read<ColoringCatalogProvider>().saveArtwork(
            page: widget.page,
            svgMarkup: session.svgMarkup,
            colors: {
              for (final entry in session.colors.entries)
                entry.key: entry.value.toARGB32(),
            },
            actions: session.actions,
            timeSpent: _timer.elapsed,
            previewBytes: preview,
          );
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('🎨 Suuraan kuufame!')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<Uint8List?> _capturePreview() async {
    final context = _captureKey.currentContext;
    if (context == null) return null;
    final boundary = context.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 2);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return data?.buffer.asUint8List();
  }

  Widget _legacyFallback() => Scaffold(
        appBar: AppBar(title: Text(widget.page.titleOromo)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 360,
                  child: ColoringFrame(
                    child: Image.asset(widget.page.image, fit: BoxFit.contain),
                  ),
                ),
                const Text(
                    'Suuraan kun qophaa’aa jira. Fuula halluu dibamu filadhu.'),
              ],
            ),
          ),
        ),
      );
}
