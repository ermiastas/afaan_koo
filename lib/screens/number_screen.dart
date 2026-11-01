import 'package:flutter/material.dart';

import '../services/content_service.dart';
import '../models/number_item.dart';

import 'number_detail_screen.dart';
import 'tracing_practice_screen.dart';

import '../widgets/lesson_complete_button.dart';
import '../utils/responsive.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({
    super.key,
  });

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  final ContentService contentService = ContentService();

  late Future<List<NumberItem>> numbers;

  @override
  void initState() {
    super.initState();

    loadNumbers();
  }

  void loadNumbers() {
    numbers = contentService.getNumbers();
  }

  Future<void> refreshNumbers() async {
    setState(() {
      loadNumbers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lakkoofsa'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.gesture,
            ),
            tooltip: "Lakkoofsa barreessi",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TracingPracticeScreen(
                    mode: TracingMode.numbers,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.refresh,
            ),
            onPressed: refreshNumbers,
          ),
        ],
      ),
      body: FutureBuilder<List<NumberItem>>(
        future: numbers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Dogoggora: ${snapshot.error}",
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Lakkoofsi hin jiru",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          }

          final numberList = snapshot.data!;

          return Column(
            children: [
              // Raji Welcome Card

              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.blue,
                      Colors.lightBlueAccent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Column(
                  children: [
                    Text(
                      "Ana Raji, waliin Lakkoofsa haa barannu!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Lakkoofsa dubbisi, lakkaa'i fi barreessi",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(Responsive.pagePadding(context)),
                  gridDelegate: Responsive.homeGridDelegate(
                    context,
                    crossAxisSpacing: Responsive.gridSpacing(context),
                    mainAxisSpacing: Responsive.gridSpacing(context),
                    childAspectRatio: Responsive.cardAspectRatio(context),
                  ),
                  itemCount: numberList.length,
                  itemBuilder: (context, index) {
                    final number = numberList[index];

                    return _NumberCard(
                      number: number,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NumberDetailScreen(
                              numbers: numberList,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: LessonCompleteButton(
                  lessonId: "numbers",
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NumberCard extends StatelessWidget {
  final NumberItem number;
  final VoidCallback onTap;

  const _NumberCard({
    required this.number,
    required this.onTap,
  });

  static const List<Color> _numberColors = [
    Color(0xFFE53935),
    Color(0xFF8E24AA),
    Color(0xFF3949AB),
    Color(0xFF00897B),
    Color(0xFFF57C00),
    Color(0xFF43A047),
    Color(0xFF039BE5),
    Color(0xFFD81B60),
  ];

  @override
  Widget build(BuildContext context) {
    final isWatch = Responsive.isWatch(context);
    final isTV = Responsive.isTV(context);

    final cardPadding = Responsive.cardPadding(context);
    final radius = Responsive.cardRadius(context);

    final colorIndex = (number.number.abs() % _numberColors.length);
    final numberColor = _numberColors[colorIndex];

    final numberSize = isWatch
        ? 34.0
        : isTV
            ? 76.0
            : 58.0;

    final oromoSize = isWatch
        ? 12.0
        : isTV
            ? 25.0
            : 19.0;

    final englishSize = isWatch
        ? 9.0
        : isTV
            ? 17.0
            : 13.0;

    return Semantics(
      button: true,
      label: '${number.number}: ${number.nameOromo}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFF3F7FF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: numberColor.withValues(alpha: 0.30),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: numberColor.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(cardPadding),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      number.number.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: numberColor,
                        fontSize: numberSize,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                        letterSpacing: -1.5,
                      ),
                    ),
                    SizedBox(height: isWatch ? 3 : 8),
                    Container(
                      height: isWatch ? 3 : 5,
                      width: isWatch ? 25 : 48,
                      decoration: BoxDecoration(
                        color: numberColor.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(height: isWatch ? 4 : 8),
                    Text(
                      number.nameOromo,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF263238),
                        fontSize: oromoSize,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      number.nameEnglish,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.blueGrey.shade500,
                        fontSize: englishSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
