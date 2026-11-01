import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:afaan_koo_app/models/content_pack.dart';
import 'package:afaan_koo_app/services/content_pack_manager.dart';
import 'package:afaan_koo_app/services/content_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDirectory;
  late Directory animalsDirectory;
  late Directory numbersDirectory;
  late Directory alphabetDirectory;
  late ContentPackManager manager;
  late ContentService contentService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    tempDirectory = await Directory.systemTemp.createTemp(
      'afaankoo_content_service_test_',
    );

    animalsDirectory = Directory(
      '${tempDirectory.path}${Platform.pathSeparator}animals',
    );
    numbersDirectory = Directory(
      '${tempDirectory.path}${Platform.pathSeparator}numbers',
    );
    alphabetDirectory = Directory(
      '${tempDirectory.path}${Platform.pathSeparator}alphabet',
    );

    await Directory(
      '${animalsDirectory.path}${Platform.pathSeparator}lessons',
    ).create(recursive: true);

    await Directory(
      '${animalsDirectory.path}${Platform.pathSeparator}media'
      '${Platform.pathSeparator}images',
    ).create(recursive: true);

    await Directory(
      '${numbersDirectory.path}${Platform.pathSeparator}lessons',
    ).create(recursive: true);

    await Directory(
      '${numbersDirectory.path}${Platform.pathSeparator}media'
      '${Platform.pathSeparator}images',
    ).create(recursive: true);

    await Directory(
      '${alphabetDirectory.path}${Platform.pathSeparator}lessons',
    ).create(recursive: true);

    await Directory(
      '${alphabetDirectory.path}${Platform.pathSeparator}media'
      '${Platform.pathSeparator}images',
    ).create(recursive: true);

    manager = ContentPackManager(
      initializationCleanup: () async {},
    );

    contentService = ContentService(
      contentPackManager: manager,
    );

    final animalsPack = ContentPack(
      id: 'animals',
      slug: 'animals',
      title: 'Animals',
      description: 'Animal lessons',
      version: 1,
      sizeBytes: 100,
      lessonCount: 1,
      category: 'animals',
      minAppVersion: '1.0.0',
      language: 'om',
      isActive: true,
      checksum: 'animals-checksum',
    );

    final numbersPack = ContentPack(
      id: 'numbers',
      slug: 'numbers',
      title: 'Numbers',
      description: 'Number lessons',
      version: 1,
      sizeBytes: 100,
      lessonCount: 1,
      category: 'numbers',
      minAppVersion: '1.0.0',
      language: 'om',
      isActive: true,
      checksum: 'numbers-checksum',
    );

    await manager.completeInstallation(
      pack: animalsPack,
      verifiedChecksum: 'animals-checksum',
      localPath: animalsDirectory.path,
    );

    await manager.completeInstallation(
      pack: numbersPack,
      verifiedChecksum: 'numbers-checksum',
      localPath: numbersDirectory.path,
    );

    final alphabetPack = ContentPack(
      id: 'alphabet',
      slug: 'alphabet',
      title: 'Alphabet',
      description: 'Alphabet lessons',
      version: 1,
      sizeBytes: 100,
      lessonCount: 1,
      category: 'alphabet',
      minAppVersion: '1.0.0',
      language: 'om',
      isActive: true,
      checksum: 'alphabet-checksum',
    );

    await manager.completeInstallation(
      pack: alphabetPack,
      verifiedChecksum: 'alphabet-checksum',
      localPath: alphabetDirectory.path,
    );
  });

  tearDown(() async {
    await tempDirectory.delete(recursive: true);
  });

  test('ContentService reads animals from the installed pack', () async {
    final lessonFile = File(
      '${animalsDirectory.path}${Platform.pathSeparator}lessons'
      '${Platform.pathSeparator}animals.json',
    );

    await lessonFile.writeAsString(
      jsonEncode([
        {
          'nameOromo': 'Leenca',
          'nameEnglish': 'Lion',
          'category': 'Wild animals',
          'image': 'media/images/lion.png',
          'sound': '',
        },
      ]),
    );

    final imageFile = File(
      '${animalsDirectory.path}${Platform.pathSeparator}media'
      '${Platform.pathSeparator}images'
      '${Platform.pathSeparator}lion.png',
    );
    await imageFile.writeAsBytes([1, 2, 3]);

    final animals = await contentService.getAnimals();

    expect(animals, hasLength(1));
    expect(animals.first.nameOromo, 'Leenca');
    expect(animals.first.nameEnglish, 'Lion');
    expect(
      animals.first.image,
      endsWith('lion.png'),
    );
    expect(File(animals.first.image).existsSync(), isTrue);
  });

  test('ContentService reads numbers from the installed pack', () async {
    final lessonFile = File(
      '${numbersDirectory.path}${Platform.pathSeparator}lessons'
      '${Platform.pathSeparator}numbers.json',
    );

    await lessonFile.writeAsString(
      jsonEncode([
        {
          'number': 1,
          'nameOromo': 'Tokko',
          'nameEnglish': 'One',
          'image': 'media/images/one.png',
          'sound': '',
          'examples': ['Fakkeenya tokko'],
        },
      ]),
    );

    final imageFile = File(
      '${numbersDirectory.path}${Platform.pathSeparator}media'
      '${Platform.pathSeparator}images'
      '${Platform.pathSeparator}one.png',
    );
    await imageFile.writeAsBytes([4, 5, 6]);

    final numbers = await contentService.getNumbers();

    expect(numbers, hasLength(1));
    expect(numbers.first.number, 1);
    expect(numbers.first.nameOromo, 'Tokko');
    expect(numbers.first.nameEnglish, 'One');
    expect(numbers.first.image, endsWith('one.png'));
    expect(File(numbers.first.image).existsSync(), isTrue);
  });
  test('ContentService merges installed alphabet examples with bundled letters',
      () async {
    final lessonFile = File(
      '${alphabetDirectory.path}${Platform.pathSeparator}lessons'
      '${Platform.pathSeparator}alphabet.json',
    );

    await lessonFile.writeAsString(
      jsonEncode([
        {
          'letter': 'A',
          'word': 'Afuura',
          'english': 'Example from installed pack',
        },
      ]),
    );

    final letters = await contentService.getLetters();
    final letterA = letters.firstWhere((letter) => letter.uppercase == 'A');
    final letterB = letters.firstWhere((letter) => letter.uppercase == 'B');

    expect(letterA.example, 'Afuura');
    expect(
      letterA.examples.any((example) => example.wordOromo == 'Afuura'),
      isTrue,
    );

    // A letter absent from the pack must retain its bundled content.
    expect(letterB.example, isNotEmpty);
    expect(letterB.name, isNotEmpty);
  });

  test(
      'ContentService falls back to bundled alphabet when pack file is missing',
      () async {
    final letters = await contentService.getLetters();

    expect(letters, isNotEmpty);
    expect(letters.any((letter) => letter.uppercase == 'A'), isTrue);
    expect(letters.any((letter) => letter.uppercase == 'B'), isTrue);
  });
}
