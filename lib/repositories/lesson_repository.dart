import '../data/lesson_categories.dart';
import '../models/lesson_category.dart';
import '../models/lesson_item.dart';

class LessonRepository {
  const LessonRepository();

  /// All categories
  List<LessonCategory> getCategories() {
    return List.unmodifiable(categories);
  }

  /// Flatten all lessons into one list
  List<LessonItem> getAllLessons() {
    return categories
        .expand((category) => category.lessons)
        .toList(growable: false);
  }

  /// Find a lesson by ID
  LessonItem? getLessonById(String id) {
    try {
      return getAllLessons().firstWhere(
        (lesson) => lesson.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  /// Search lessons
  List<LessonItem> search(String query) {
    if (query.trim().isEmpty) {
      return [];
    }

    final q = query.toLowerCase();

    return getAllLessons().where((lesson) {
      return lesson.title.toLowerCase().contains(q) ||
          lesson.description.toLowerCase().contains(q);
    }).toList();
  }
}