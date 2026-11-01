import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../models/learning_item.dart';
import '../services/audio_service.dart';
import '../services/badge_service.dart';
import '../services/progress_service.dart';
import '../utils/responsive.dart';
import '../widgets/lesson_complete_button.dart';
import '../widgets/reward_dialog.dart';

class LearningScreen extends StatefulWidget {
  final String title;
  final Color color;
  final List<LearningItem> items;
  final String rajiMessage;
  final String lessonId;

  const LearningScreen({
    super.key,
    required this.title,
    required this.color,
    required this.items,
    required this.rajiMessage,
    required this.lessonId,
  });

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  late final ConfettiController confettiController;

  final AudioService audioService = AudioService();

  @override
  void initState() {
    super.initState();

    confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    confettiController.dispose();

    // AudioService is shared/lazy-managed.
    // Do not dispose its player from an individual learning screen.
    super.dispose();
  }

  Future<void> completeLesson() async {
    confettiController.play();

    await ProgressService.addStar(5);
    await ProgressService.completeLesson();

    String? badge;

    if (widget.lessonId == 'alphabet') {
      badge = 'alphabet';
    } else if (widget.lessonId == 'animals') {
      badge = 'animals';
    } else if (widget.lessonId == 'plants' || widget.lessonId == 'weather') {
      badge = 'nature';
    }

    if (badge != null) {
      await BadgeService.unlockBadge(badge);
    }

    await audioService.playSound(
      'assets/audio/reward.mp3',
    );

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return RewardDialog(
          stars: 5,
          rajiMessage: widget.rajiMessage,
          badge: badge,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWatch = Responsive.isWatch(context);
    final isTV = Responsive.isTV(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        backgroundColor: widget.color,
        titleTextStyle: TextStyle(
          fontSize: Responsive.subtitleSize(context),
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _rajiHeader(context),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(
                    Responsive.pagePadding(context),
                  ),
                  itemCount: widget.items.length,
                  gridDelegate: Responsive.homeGridDelegate(
                    context,
                    crossAxisSpacing: Responsive.gridSpacing(context),
                    mainAxisSpacing: Responsive.gridSpacing(context),
                    childAspectRatio: Responsive.cardAspectRatio(context),
                  ),
                  itemBuilder: (context, index) {
                    final item = widget.items[index];

                    return _learningCard(
                      context,
                      item,
                      isWatch: isWatch,
                      isTV: isTV,
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  Responsive.pagePadding(context),
                ),
                child: LessonCompleteButton(
                  lessonId: widget.lessonId,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: isWatch
                  ? 15
                  : isTV
                      ? 70
                      : 40,
              gravity: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rajiHeader(BuildContext context) {
    final isWatch = Responsive.isWatch(context);
    final isTV = Responsive.isTV(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.pagePadding(context),
        vertical: isWatch
            ? 8
            : isTV
                ? 30
                : 20,
      ),
      decoration: BoxDecoration(
        color: widget.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(
            isWatch
                ? 16
                : isTV
                    ? 40
                    : 30,
          ),
          bottomRight: Radius.circular(
            isWatch
                ? 16
                : isTV
                    ? 40
                    : 30,
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            '😊 Raji',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isWatch
                  ? 20
                  : isTV
                      ? 40
                      : 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: isWatch
                ? 4
                : isTV
                    ? 12
                    : 8,
          ),
          Text(
            widget.rajiMessage,
            textAlign: TextAlign.center,
            maxLines: isWatch ? 2 : 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: Responsive.bodySize(context),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _learningCard(
    BuildContext context,
    LearningItem item, {
    required bool isWatch,
    required bool isTV,
  }) {
    final radius = Responsive.cardRadius(context);
    final padding = Responsive.cardPadding(context);

    return Semantics(
      button: true,
      label: '${item.nameOromo}, ${item.nameEnglish}',
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: () async {
          await audioService.playSound(item.sound);
        },
        child: Card(
          elevation: isTV ? 8 : 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(
                      isWatch
                          ? 4
                          : isTV
                              ? 18
                              : 12,
                    ),
                    child: Image.asset(
                      item.image,
                      fit: BoxFit.contain,
                      errorBuilder: (
                        context,
                        error,
                        stack,
                      ) {
                        return Icon(
                          Icons.image,
                          size: isWatch
                              ? 36
                              : isTV
                                  ? 100
                                  : 80,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: isWatch
                      ? 4
                      : isTV
                          ? 14
                          : 10,
                ),
                Text(
                  item.nameOromo,
                  textAlign: TextAlign.center,
                  maxLines: isWatch ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: Responsive.subtitleSize(context),
                    fontWeight: FontWeight.bold,
                    height: 1.15,
                  ),
                ),
                Text(
                  item.nameEnglish,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: Responsive.bodySize(context),
                    height: 1.15,
                  ),
                ),
                SizedBox(
                  height: isWatch
                      ? 4
                      : isTV
                          ? 12
                          : 10,
                ),
                Icon(
                  Icons.volume_up,
                  color: widget.color,
                  size: isWatch
                      ? 20
                      : isTV
                          ? 42
                          : 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
