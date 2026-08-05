import 'package:flutter/foundation.dart';

import '../models/lesson_category.dart';
import '../models/lesson_item.dart';
import '../repositories/lesson_repository.dart';

class LessonProvider extends ChangeNotifier {
  LessonProvider({
    LessonRepository? repository,
  }) : _repository = repository ?? const LessonRepository() {
    _load();
  }

  final LessonRepository _repository;

  List<LessonCategory> _categories = [];
  List<LessonItem> _searchResults = [];

  LessonItem? _currentLesson;
  LessonItem? _continueLesson;

  String _searchQuery = '';

  //--------------------------------------------------
  // Load
  //--------------------------------------------------

  void _load() {
    _categories = _repository.getCategories();
  }

  //--------------------------------------------------
  // Getters
  //--------------------------------------------------

  List<LessonCategory> get categories =>
      List.unmodifiable(_categories);

  List<LessonItem> get searchResults =>
      List.unmodifiable(_searchResults);

  LessonItem? get currentLesson =>
      _currentLesson;

  LessonItem? get continueLesson =>
      _continueLesson;

  String get searchQuery =>
      _searchQuery;

  int get categoryCount =>
      _categories.length;

  int get lessonCount =>
      _categories.fold(
        0,
        (sum, category) => sum + category.lessons.length,
      );

  //--------------------------------------------------
  // Search
  //--------------------------------------------------

  void search(String value) {
    _searchQuery = value;

    _searchResults = _repository.search(value);

    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }

  //--------------------------------------------------
  // Continue Learning
  //--------------------------------------------------

  void openLesson(LessonItem lesson) {
    _currentLesson = lesson;
    _continueLesson = lesson;

    notifyListeners();
  }

  //--------------------------------------------------
  // Refresh
  //--------------------------------------------------

  void refresh() {
    _load();
    notifyListeners();
  }
}