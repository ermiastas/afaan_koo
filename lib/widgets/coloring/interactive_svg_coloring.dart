import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xml/xml.dart';

import '../../models/coloring_action.dart';
import '../../services/coloring_progress_service.dart';
import '../../services/coloring_state_service.dart';
import '../../services/svg_color_engine.dart';

class InteractiveSvgColoring extends StatefulWidget {
  const InteractiveSvgColoring({
    super.key,
    required this.pageId,
    required this.selectedColor,
    this.svgMarkup,
    this.svgAsset,
    this.service,
    this.pageReward = 0,
    this.onChanged,
    this.onCompleted,
  }) : assert(svgMarkup != null || svgAsset != null);

  final String pageId;
  final String? svgMarkup;
  final String? svgAsset;
  final Color selectedColor;
  final ColoringStateService? service;
  final int pageReward;
  final ValueChanged<ColoringSession>? onChanged;
  final VoidCallback? onCompleted;

  @override
  State<InteractiveSvgColoring> createState() =>
      InteractiveSvgColoringState();
}

class ColoringSession {
  const ColoringSession({
    required this.svgMarkup,
    required this.colors,
    required this.actions,
  });

  final String svgMarkup;
  final Map<String, Color> colors;
  final List<ColoringAction> actions;
}

class InteractiveSvgColoringState
    extends State<InteractiveSvgColoring> {

  final SvgColorEngine _colorEngine = SvgColorEngine();

  final ColoringProgressService _progressService =
      ColoringProgressService();

  final Map<String, Color> _colors = <String, Color>{};

  final List<_PaintChange> _undo = <_PaintChange>[];
  final List<_PaintChange> _redo = <_PaintChange>[];

  final List<ColoringAction> _actions =
      <ColoringAction>[];

  List<_RegionGeometry> _regions =
      const <_RegionGeometry>[];

  Rect _viewBox = const Rect.fromLTWH(0, 0, 96, 96);

  String? _originalSvg;
  String? _renderedSvg;

  bool _loading = true;
  bool _replaying = false;
  bool _completionAnnounced = false;

  bool get canUndo => _undo.isNotEmpty;

  bool get canRedo => _redo.isNotEmpty;

  bool get isReplaying => _replaying;

  bool get isReady {
    return !_loading &&
        _renderedSvg != null &&
        _renderedSvg!.trim().isNotEmpty &&
        _regions.isNotEmpty;
  }

  ColoringSession get session {
    return ColoringSession(
      svgMarkup: _renderedSvg ?? _originalSvg ?? '',
      colors: Map<String, Color>.unmodifiable(
        _colors,
      ),
      actions: List<ColoringAction>.unmodifiable(
        _actions,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(
    covariant InteractiveSvgColoring oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.svgMarkup != widget.svgMarkup ||
        oldWidget.svgAsset != widget.svgAsset ||
        oldWidget.pageId != widget.pageId) {
      _load();
    }
  }

  // ===========================================================================
  // LOAD SVG
  // ===========================================================================

  Future<void> _load() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    try {
      String svg;

      if (widget.svgMarkup != null &&
          widget.svgMarkup!.trim().isNotEmpty) {
        svg = widget.svgMarkup!;
      } else if (widget.svgAsset != null &&
          widget.svgAsset!.trim().isNotEmpty) {
        svg = await rootBundle.loadString(
          widget.svgAsset!,
        );
      } else {
        throw StateError(
          'No SVG markup or SVG asset was provided.',
        );
      }

      if (svg.trim().isEmpty) {
        throw StateError(
          'SVG content is empty.',
        );
      }

      _viewBox = _parseViewBox(svg);
      final regions = _parseRegions(svg);

      debugPrint(
        '🎨 Coloring page: ${widget.pageId}',
      );

      debugPrint(
        '🎨 SVG length: ${svg.length}',
      );

      debugPrint(
        '🎨 SVG regions detected: ${regions.length}',
      );

      if (regions.isEmpty) {
        throw StateError(
          'SVG contains no usable colouring regions.',
        );
      }

      final saved =
          await _progressService.loadColoring(
        widget.pageId,
      );

      final validIds = regions
          .map(
            (region) => region.id,
          )
          .toSet();

      _colors.clear();

      for (final entry in saved.entries) {
        if (validIds.contains(entry.key)) {
          _colors[entry.key] = entry.value;
        }
      }

      _regions = regions;
      _originalSvg = svg;

      _refreshSvg();

      if (mounted) {
        setState(() {});
      }
    } catch (error, stackTrace) {
      debugPrint(
        '❌ Coloring load failed: $error',
      );

      debugPrint(
        '$stackTrace',
      );

      if (mounted) {
        setState(() {
          _originalSvg = null;
          _renderedSvg = null;
          _regions = const <_RegionGeometry>[];
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // ===========================================================================
  // SVG REGION PARSER
  // ===========================================================================

  Rect _parseViewBox(String svg) {
    try {
      final root = XmlDocument.parse(svg).rootElement;
      final values = (root.getAttribute('viewBox') ?? '')
          .split(RegExp(r'[ ,]+'))
          .map(double.tryParse)
          .whereType<double>()
          .toList(growable: false);
      if (values.length == 4 && values[2] > 0 && values[3] > 0) {
        return Rect.fromLTWH(values[0], values[1], values[2], values[3]);
      }
    } catch (_) {
      // The region parser will show the normal SVG error state if needed.
    }
    return const Rect.fromLTWH(0, 0, 96, 96);
  }

  List<_RegionGeometry> _parseRegions(
    String svg,
  ) {
    final regions = <_RegionGeometry>[];

    late XmlDocument document;

    try {
      document = XmlDocument.parse(svg);
    } catch (error) {
      debugPrint(
        '❌ SVG XML parsing failed: $error',
      );

      return regions;
    }

    final paths =
        document.findAllElements('path');

    for (final path in paths) {
      final id = path.getAttribute('id');
      final data = path.getAttribute('d');

      if (id == null ||
          id.trim().isEmpty ||
          data == null ||
          data.trim().isEmpty) {
        continue;
      }

      final rectangles =
          _parseScanlineRectangles(data);

      if (rectangles.isNotEmpty) {
        regions.add(
          _RegionGeometry(
            id,
            rectangles,
          ),
        );

        continue;
      }

      // Fallback for normal SVG paths.
      final bounds =
          _calculatePathBounds(data);

      if (bounds != null &&
          bounds.width > 0 &&
          bounds.height > 0) {
        regions.add(
          _RegionGeometry(
            id,
            <Rect>[bounds],
          ),
        );
      }
    }

    return _removeDuplicateRegionIds(
      regions,
    );
  }

  List<_RegionGeometry>
      _removeDuplicateRegionIds(
    List<_RegionGeometry> regions,
  ) {
    final result =
        <_RegionGeometry>[];

    final usedIds =
        <String>{};

    for (final region in regions) {
      if (usedIds.add(region.id)) {
        result.add(region);
      }
    }

    return result;
  }

  // ===========================================================================
  // SCANLINE RECTANGLE PARSER
  // ===========================================================================

  List<Rect> _parseScanlineRectangles(
    String data,
  ) {
    final rectangles = <Rect>[];

    final matcher = RegExp(
      r'M\s*(-?\d+(?:\.\d+)?)\s+'
      r'(-?\d+(?:\.\d+)?)\s*'
      r'H\s*(-?\d+(?:\.\d+)?)\s*'
      r'V\s*(-?\d+(?:\.\d+)?)\s*'
      r'H\s*(-?\d+(?:\.\d+)?)\s*'
      r'Z',
      caseSensitive: false,
    );

    for (final match
        in matcher.allMatches(data)) {
      final x1 = double.tryParse(
        match.group(1) ?? '',
      );

      final y1 = double.tryParse(
        match.group(2) ?? '',
      );

      final x2 = double.tryParse(
        match.group(3) ?? '',
      );

      final y2 = double.tryParse(
        match.group(4) ?? '',
      );

      if (x1 == null ||
          y1 == null ||
          x2 == null ||
          y2 == null) {
        continue;
      }

      final left =
          x1 < x2 ? x1 : x2;

      final right =
          x1 > x2 ? x1 : x2;

      final top =
          y1 < y2 ? y1 : y2;

      final bottom =
          y1 > y2 ? y1 : y2;

      if (right <= left ||
          bottom <= top) {
        continue;
      }

      rectangles.add(
        Rect.fromLTRB(
          left,
          top,
          right,
          bottom,
        ),
      );
    }

    return rectangles;
  }

  // ===========================================================================
  // GENERIC PATH BOUNDS
  // ===========================================================================

  Rect? _calculatePathBounds(
    String data,
  ) {
    final numberPattern = RegExp(
      r'-?\d+(?:\.\d+)?',
    );

    final numbers = numberPattern
        .allMatches(data)
        .map(
          (match) => double.tryParse(
            match.group(0)!,
          ),
        )
        .whereType<double>()
        .toList();

    if (numbers.length < 2) {
      return null;
    }

    var minX = double.infinity;
    var minY = double.infinity;

    var maxX =
        double.negativeInfinity;

    var maxY =
        double.negativeInfinity;

    for (var i = 0;
        i + 1 < numbers.length;
        i += 2) {
      final x = numbers[i];
      final y = numbers[i + 1];

      if (x < minX) {
        minX = x;
      }

      if (x > maxX) {
        maxX = x;
      }

      if (y < minY) {
        minY = y;
      }

      if (y > maxY) {
        maxY = y;
      }
    }

    if (!minX.isFinite ||
        !minY.isFinite ||
        !maxX.isFinite ||
        !maxY.isFinite) {
      return null;
    }

    return Rect.fromLTRB(
      minX,
      minY,
      maxX,
      maxY,
    );
  }

  // ===========================================================================
  // COLOR
  // ===========================================================================

  void fillRegion(
    String id,
    Color color,
  ) {
    if (_loading || _replaying) {
      return;
    }

    final exists = _regions.any(
      (region) => region.id == id,
    );

    if (!exists) {
      return;
    }

    final before =
        _colors[id] ?? Colors.white;

    if (before.toARGB32() ==
        color.toARGB32()) {
      return;
    }

    final change = _PaintChange(
      id,
      before,
      color,
    );

    _apply(
      change,
      record: true,
    );
  }

  void eraseRegion(
    String id,
  ) {
    fillRegion(
      id,
      Colors.white,
    );
  }

  // ===========================================================================
  // UNDO
  // ===========================================================================

  void undo() {
    if (_undo.isEmpty ||
        _replaying) {
      return;
    }

    final change =
        _undo.removeLast();

    _apply(
      change.reversed,
      record: false,
    );

    _redo.add(change);
  }

  // ===========================================================================
  // REDO
  // ===========================================================================

  void redo() {
    if (_redo.isEmpty ||
        _replaying) {
      return;
    }

    final change =
        _redo.removeLast();

    _apply(
      change,
      record: false,
    );

    _undo.add(change);
  }

  // ===========================================================================
  // CLEAR
  // ===========================================================================

  void clear() {
    if (_colors.isEmpty ||
        _replaying) {
      return;
    }

    final changes = _colors.entries
        .map(
          (entry) => _PaintChange(
            entry.key,
            entry.value,
            Colors.white,
          ),
        )
        .toList();

    for (final change in changes) {
      _colors[change.id] =
          Colors.white;

      widget.service?.updateColor(
        change.id,
        Colors.white,
      );
    }

    _undo.addAll(changes);
    _redo.clear();

    _actions.add(
      ColoringAction(
        regionId: '*',
        type: ColoringActionType.clear,
        at: DateTime.now(),
      ),
    );

    _refreshSvg();

    _persistAndNotify();

    if (mounted) {
      setState(() {});
    }
  }

  // ===========================================================================
  // REPLAY
  // ===========================================================================

  Future<void> replay({
    Duration step =
        const Duration(
      milliseconds: 340,
    ),
  }) async {
    if (_replaying ||
        _actions.isEmpty) {
      return;
    }

    final replayActions =
        List<ColoringAction>.from(
      _actions,
    );

    if (mounted) {
      setState(() {
        _replaying = true;
        _colors.clear();
        _refreshSvg();
      });
    }

    for (final action
        in replayActions) {
      if (!mounted) {
        return;
      }

      if (action.type ==
          ColoringActionType.clear) {
        _colors.clear();
      } else if (action.colorValue !=
          null) {
        _colors[action.regionId] =
            Color(
          action.colorValue!,
        );
      }

      _refreshSvg();

      if (mounted) {
        setState(() {});
      }

      await Future<void>.delayed(
        step,
      );
    }

    if (mounted) {
      setState(() {
        _replaying = false;
      });
    }
  }

  // ===========================================================================
  // APPLY CHANGE
  // ===========================================================================

  void _apply(
    _PaintChange change, {
    required bool record,
  }) {
    _colors[change.id] =
        change.after;

    widget.service?.updateColor(
      change.id,
      change.after,
    );

    if (record) {
      _undo.add(change);
      _redo.clear();

      _actions.add(
        ColoringAction(
          regionId: change.id,
          type: change.after ==
                  Colors.white
              ? ColoringActionType.erase
              : ColoringActionType.fill,
          colorValue:
              change.after.toARGB32(),
          previousColorValue:
              change.before.toARGB32(),
          at: DateTime.now(),
        ),
      );
    }

    _refreshSvg();

    _persistAndNotify();

    if (mounted) {
      setState(() {});
    }
  }

  // ===========================================================================
  // SVG RECOLOR
  // ===========================================================================

  void _refreshSvg() {
    final source = _originalSvg;

    if (source == null ||
        source.trim().isEmpty) {
      return;
    }

    try {
      _renderedSvg =
          _colorEngine.recolorMarkup(
        svg: source,
        colors: {
          for (final entry
              in _colors.entries)
            entry.key:
                _hex(entry.value),
        },
      );
    } catch (error) {
      debugPrint(
        '❌ SVG recoloring failed: $error',
      );

      _renderedSvg = source;
    }
  }

  // ===========================================================================
  // SAVE
  // ===========================================================================

  Future<void> _persistAndNotify() async {
    try {
      await _progressService.saveColoring(
        pageId: widget.pageId,
        colors: _colors,
      );
    } catch (error) {
      debugPrint(
        '⚠️ Coloring save failed: $error',
      );
    }

    if (!mounted) {
      return;
    }

    widget.onChanged?.call(
      session,
    );

    final colouredCount =
        _colors.values
            .where(
              (color) =>
                  color.toARGB32() !=
                  Colors.white.toARGB32(),
            )
            .length;

    if (!_completionAnnounced &&
        _regions.isNotEmpty &&
        colouredCount >=
            _regions.length) {
      _completionAnnounced = true;

      widget.onCompleted?.call();
    }
  }

  String _hex(Color color) {
    final argb =
        color.toARGB32();

    final rgb =
        argb & 0x00FFFFFF;

    return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  // ===========================================================================
  // HIT TEST
  // ===========================================================================

  _RegionGeometry? _findRegionAt({
    required Offset localPosition,
    required double canvasSize,
  }) {
    if (canvasSize <= 0) {
      return null;
    }

    final x = _viewBox.left +
        (localPosition.dx / canvasSize * _viewBox.width);

    final y = _viewBox.top +
        (localPosition.dy / canvasSize * _viewBox.height);

    final point =
        Offset(x, y);

    final matching =
        _regions.where(
      (region) =>
          region.contains(point),
    ).toList();

    if (matching.isEmpty) {
      return null;
    }

    // Smaller regions first.
    matching.sort(
      (a, b) =>
          a.area.compareTo(b.area),
    );

    return matching.first;
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    if (_loading) {
      return const Center(
        child:
            CircularProgressIndicator(),
      );
    }

    if (_renderedSvg == null ||
        _renderedSvg!.trim().isEmpty) {
      return _buildErrorState(
        'Suuraa halluu dibamu hin qophoofne.',
      );
    }

    if (_regions.isEmpty) {
      return _buildErrorState(
        'Kutaan halluu dibamu hin argamne.',
      );
    }

    // IMPORTANT:
    //
    // The previous version used a fixed 360x360 SizedBox.
    // That can cause RenderFlex / RenderBox problems when this
    // widget is placed inside a Column with limited height.
    //
    // LayoutBuilder gives us the actual available space.
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        final availableWidth =
            constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : 360.0;

        final availableHeight =
            constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : 360.0;

        // Leave a small safety margin.
        final safeWidth =
            (availableWidth - 16)
                .clamp(120.0, 900.0)
                .toDouble();

        final safeHeight =
            (availableHeight - 16)
                .clamp(120.0, 900.0)
                .toDouble();

        final canvasSize =
            safeWidth < safeHeight
                ? safeWidth
                : safeHeight;

        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: InteractiveViewer(
            minScale: 0.8,
            maxScale: 5.0,
            panEnabled: true,
            scaleEnabled: true,
            boundaryMargin:
                const EdgeInsets.all(80),
            child: Center(
              child: SizedBox(
                width: canvasSize,
                height: canvasSize,
                child: _buildCanvas(
                  canvasSize,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // CANVAS
  // ===========================================================================

  Widget _buildCanvas(
    double canvasSize,
  ) {
    return GestureDetector(
      behavior:
          HitTestBehavior.opaque,
      onTapUp: (details) {
        if (_replaying) {
          return;
        }

        final region =
            _findRegionAt(
          localPosition:
              details.localPosition,
          canvasSize: canvasSize,
        );

        if (region != null) {
          fillRegion(
            region.id,
            widget.selectedColor,
          );
        }
      },
      child: RepaintBoundary(
        child: SizedBox(
          width: canvasSize,
          height: canvasSize,
          child: SvgPicture.string(
            _renderedSvg!,
            fit: BoxFit.contain,
            width: canvasSize,
            height: canvasSize,
            allowDrawingOutsideViewBox:
                false,
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // ERROR UI
  // ===========================================================================

  Widget _buildErrorState(
    String message,
  ) {
    return Center(
      child: SingleChildScrollView(
        padding:
            const EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Icon(
              Icons
                  .image_not_supported_rounded,
              size: 56,
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              message,
              textAlign:
                  TextAlign.center,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'SVG regions: ${_regions.length}',
              textAlign:
                  TextAlign.center,
              style:
                  Theme.of(context)
                      .textTheme
                      .bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// REGION GEOMETRY
// ============================================================================

class _RegionGeometry {
  const _RegionGeometry(
    this.id,
    this.rectangles,
  );

  final String id;
  final List<Rect> rectangles;

  Rect get bounds {
    if (rectangles.isEmpty) {
      return Rect.zero;
    }

    var minLeft =
        rectangles.first.left;

    var minTop =
        rectangles.first.top;

    var maxRight =
        rectangles.first.right;

    var maxBottom =
        rectangles.first.bottom;

    for (final rectangle
        in rectangles.skip(1)) {
      if (rectangle.left <
          minLeft) {
        minLeft =
            rectangle.left;
      }

      if (rectangle.top <
          minTop) {
        minTop =
            rectangle.top;
      }

      if (rectangle.right >
          maxRight) {
        maxRight =
            rectangle.right;
      }

      if (rectangle.bottom >
          maxBottom) {
        maxBottom =
            rectangle.bottom;
      }
    }

    return Rect.fromLTRB(
      minLeft,
      minTop,
      maxRight,
      maxBottom,
    );
  }

  double get area {
    return bounds.width *
        bounds.height;
  }

  bool contains(Offset point) {
    for (final rectangle
        in rectangles) {
      if (rectangle.contains(point)) {
        return true;
      }
    }

    return false;
  }
}

// ============================================================================
// PAINT CHANGE
// ============================================================================

class _PaintChange {
  const _PaintChange(
    this.id,
    this.before,
    this.after,
  );

  final String id;
  final Color before;
  final Color after;

  _PaintChange get reversed {
    return _PaintChange(
      id,
      after,
      before,
    );
  }
}
