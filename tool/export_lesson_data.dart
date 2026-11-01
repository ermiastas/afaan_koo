import 'dart:convert';
import 'dart:io';

import 'package:afaan_koo_app/data/math_data.dart' as math_data;
import 'package:afaan_koo_app/data/time_game_data.dart' as time_game_data;
import 'package:afaan_koo_app/data/plant_data.dart' as plant_data;
import 'package:afaan_koo_app/data/weather_data.dart' as weather_data;
import 'package:afaan_koo_app/data/fruit_data.dart' as fruit_data;
import 'package:afaan_koo_app/data/vegetable_data.dart' as vegetable_data;
import 'package:afaan_koo_app/data/home_object_data.dart' as home_object_data;
import 'package:afaan_koo_app/data/coloring_data.dart' as coloring_data;
import 'package:afaan_koo_app/data/market_data.dart' as market_data;
import 'package:afaan_koo_app/data/money_data.dart' as money_data;
import 'package:afaan_koo_app/data/time_data.dart' as time_data;
import 'package:afaan_koo_app/data/month_data.dart' as month_data;
import 'package:afaan_koo_app/data/occupation_data.dart' as occupation_data;
import 'package:afaan_koo_app/data/transport_data.dart' as transport_data;
import 'package:afaan_koo_app/data/hygiene_data.dart' as hygiene_data;
import 'package:afaan_koo_app/data/traffic_data.dart' as traffic_data;
import 'package:afaan_koo_app/data/oromo_culture_data.dart'
    as oromo_culture_data;
import 'package:afaan_koo_app/data/hibboo_data.dart' as hibboo_data;
import 'package:afaan_koo_app/data/mammaaksa_data.dart' as mammaaksa_data;
import 'package:afaan_koo_app/data/school_data.dart' as school_data;
import 'package:afaan_koo_app/data/school_supplies_data.dart'
    as school_supplies_data;
import 'package:afaan_koo_app/data/shape_data.dart' as shape_data;
import 'package:afaan_koo_app/data/multiplication_game_data.dart'
    as multiplication_data;
import 'package:afaan_koo_app/data/division_game_data.dart' as division_data;
import 'package:afaan_koo_app/data/handwriting_data.dart' as handwriting_data;

const String outputDirectory = 'build/lesson_export_phase2';

Map<String, dynamic> learningItem(dynamic item) => {
      'nameOromo': item.nameOromo,
      'nameEnglish': item.nameEnglish,
      'image': item.image,
      'sound': item.sound,
    };

Map<String, dynamic> fruitItem(dynamic item) => {
      'nameOromo': item.nameOromo,
      'nameEnglish': item.nameEnglish,
      'image': item.image,
      'sound': item.sound,
    };

Map<String, dynamic> coloringPage(dynamic item) => {
      'id': item.id,
      'category': item.category,
      'titleOromo': item.titleOromo,
      'titleEnglish': item.titleEnglish,
      'image': item.image,
      'thumbnail': item.thumbnail,
      'sound': item.sound,
      'emoji': item.emoji,
      'rewardXP': item.rewardXP,
      'difficulty': item.difficulty,
      'premium': item.premium,
      'ages': item.ages,
      'tags': item.tags,
      'svgMarkup': item.svgMarkup,
      'lessonId': item.lessonId,
      'lessonTitle': item.lessonTitle,
      'sourceAssetId': item.sourceAssetId,
      'isNew': item.isNew,
    };

Map<String, dynamic> hibbooItem(dynamic item) => {
      'id': item.id,
      'question': item.question,
      'hint': item.hint,
      'answer': item.answer,
      'emoji': item.emoji,
      'audio': item.audio,
      'category': item.category,
      'difficulty': item.difficulty.toString().split('.').last,
      'xpReward': item.xpReward,
      'coinsReward': item.coinsReward,
    };

Map<String, dynamic> mammaaksaItem(dynamic item) => {
      'id': item.id,
      'proverb': item.proverb,
      'meaning': item.meaning,
      'hint': item.hint,
      'emoji': item.emoji,
      'audio': item.audio,
      'category': item.category,
      'difficulty': item.difficulty.toString().split('.').last,
      'xpReward': item.xpReward,
      'coinsReward': item.coinsReward,
    };

Map<String, dynamic> mathLesson(dynamic item) => {
      'id': item.id,
      'titleOromo': item.titleOromo,
      'titleEnglish': item.titleEnglish,
      'description': item.description,
      'image': item.image,
      'category': item.category,
    };

Map<String, dynamic> timeQuestion(dynamic item) => {
      'hour': item.hour,
      'minute': item.minute,
      'activity': item.activity,
      'answer': item.answer,
    };

Map<String, dynamic> multiplicationQuestion(dynamic item) => {
      'groups': item.groups,
      'items': item.items,
      'answer': item.answer,
    };

Map<String, dynamic> divisionQuestion(dynamic item) => {
      'total': item.total,
      'groups': item.groups,
      'answer': item.answer,
    };

Map<String, dynamic> handwritingItem(dynamic item) => {
      'character': item.character,
      'lowercase': item.lowercase,
      'name': item.name,
      'sound': item.sound,
      'category': item.category,
      'strokes': (item.strokes as Iterable)
          .map((stroke) => {
                'order': stroke.order,
                'points': stroke.points,
                'direction': stroke.direction,
              })
          .toList(),
    };

Future<void> main() async {
  final outputRoot = Directory(outputDirectory);

  if (await outputRoot.exists()) {
    stderr.writeln(
      'ERROR: Export directory already exists: ${outputRoot.path}',
    );
    stderr.writeln(
      'Move or rename it before running the exporter again.',
    );
    exitCode = 1;
    return;
  }

  await outputRoot.create(recursive: true);

  final report = <Map<String, dynamic>>[];

  Future<void> exportPack({
    required String id,
    required Iterable<dynamic> records,
    required Map<String, dynamic> Function(dynamic) serialize,
  }) async {
    try {
      final items = records.map(serialize).toList();

      if (items.isEmpty) {
        throw StateError('No records found for this pack.');
      }

      final file = File('${outputRoot.path}/$id.json');

      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(items),
        encoding: utf8,
      );

      report.add({
        'packId': id,
        'file': '$id.json',
        'recordCount': items.length,
        'status': 'SUCCESS',
      });

      stdout.writeln('SUCCESS  $id  (${items.length} records)');
    } catch (error, stackTrace) {
      report.add({
        'packId': id,
        'recordCount': 0,
        'status': 'FAILED',
        'error': error.toString(),
        'stackTrace': stackTrace.toString(),
      });

      stderr.writeln('FAILED   $id: $error');
    }
  }

  await exportPack(
    id: 'math',
    records: math_data.mathLessons,
    serialize: mathLesson,
  );

  await exportPack(
    id: 'time_math',
    records: time_game_data.generateTimeQuestions(),
    serialize: timeQuestion,
  );

  await exportPack(
    id: 'plants',
    records: plant_data.plantData,
    serialize: learningItem,
  );

  await exportPack(
    id: 'weather',
    records: weather_data.weatherData,
    serialize: learningItem,
  );

  await exportPack(
    id: 'fruits',
    records: fruit_data.fruitData,
    serialize: fruitItem,
  );

  await exportPack(
    id: 'vegetables',
    records: vegetable_data.vegetableData,
    serialize: fruitItem,
  );

  await exportPack(
    id: 'home_objects',
    records: home_object_data.homeObjectData,
    serialize: learningItem,
  );

  await exportPack(
    id: 'coloring',
    records: coloring_data.coloringPages,
    serialize: coloringPage,
  );

  await exportPack(
    id: 'market',
    records: market_data.marketData,
    serialize: learningItem,
  );

  await exportPack(
    id: 'money',
    records: money_data.moneyData,
    serialize: learningItem,
  );

  await exportPack(
    id: 'time',
    records: time_data.timeData,
    serialize: learningItem,
  );

  await exportPack(
    id: 'month',
    records: month_data.monthData,
    serialize: learningItem,
  );

  await exportPack(
    id: 'occupation',
    records: occupation_data.occupationData,
    serialize: learningItem,
  );

  await exportPack(
    id: 'transport',
    records: transport_data.transportData,
    serialize: learningItem,
  );

  await exportPack(
    id: 'hygiene',
    records: hygiene_data.hygieneData,
    serialize: learningItem,
  );

  await exportPack(
    id: 'traffic',
    records: traffic_data.trafficData,
    serialize: learningItem,
  );

  await exportPack(
    id: 'oromo_culture',
    records: oromo_culture_data.oromoCultureData,
    serialize: learningItem,
  );

  await exportPack(
    id: 'hibboo',
    records: hibboo_data.hibbooData,
    serialize: hibbooItem,
  );

  await exportPack(
    id: 'mammaaksa',
    records: mammaaksa_data.mammaaksaData,
    serialize: mammaaksaItem,
  );

  await exportPack(
    id: 'school',
    records: school_data.schoolData,
    serialize: learningItem,
  );

  await exportPack(
    id: 'school_supplies',
    records: school_supplies_data.schoolSuppliesData,
    serialize: learningItem,
  );

  await exportPack(
    id: 'shape',
    records: shape_data.shapeData,
    serialize: learningItem,
  );

  await exportPack(
    id: 'multiplication_game',
    records: multiplication_data.generateMultiplicationQuestions(),
    serialize: multiplicationQuestion,
  );

  await exportPack(
    id: 'division_game',
    records: division_data.generateDivisionQuestions(),
    serialize: divisionQuestion,
  );

  await exportPack(
    id: 'handwriting',
    records: handwriting_data.handwritingData,
    serialize: handwritingItem,
  );

  final successful = report
      .where(
        (item) => item['status'] == 'SUCCESS',
      )
      .length;

  final failed = report.length - successful;

  final summary = {
    'exportVersion': 1,
    'totalPacks': report.length,
    'successfulPacks': successful,
    'failedPacks': failed,
    'totalRecords': report.fold<int>(
      0,
      (sum, item) => sum + (item['recordCount'] as int),
    ),
    'packs': report,
  };

  await File('${outputRoot.path}/export_report.json').writeAsString(
    const JsonEncoder.withIndent('  ').convert(summary),
    encoding: utf8,
  );

  stdout.writeln('');
  stdout.writeln('========== EXPORT SUMMARY ==========');
  stdout.writeln('Total packs:      ${report.length}');
  stdout.writeln('Successful:       $successful');
  stdout.writeln('Failed:           $failed');
  stdout.writeln('Total records:    ${summary['totalRecords']}');
  stdout.writeln('Output:           ${outputRoot.path}');
  stdout.writeln('====================================');

  if (failed > 0) {
    exitCode = 1;
  }
}
