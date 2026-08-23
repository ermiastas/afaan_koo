import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ParentDashboardProvider extends ChangeNotifier {
  // ============================================================
  // SUPABASE
  // ============================================================

  final SupabaseClient _supabase = Supabase.instance.client;

  // ============================================================
  // STATE
  // ============================================================

  bool _isLoading = false;

  String? _error;

  String? _studentId;

  String _studentName = 'Barataa Afaan Koo';

  String? _studentAvatar;

  int _completedLessons = 0;

  int _totalLessons = 0;

  int _learningMinutes = 0;

  int _xp = 0;

  int _coins = 0;

  int _stars = 0;

  int _level = 1;

  double _completionPercentage = 0;

  final List<String> _completedLessonIds = [];

  final List<Map<String, dynamic>> _badges = [];

  // ============================================================
  // GETTERS
  // ============================================================

  bool get isLoading => _isLoading;

  String? get error => _error;

  String? get studentId => _studentId;

  String get studentName => _studentName;

  String? get studentAvatar => _studentAvatar;

  int get completedLessons => _completedLessons;

  int get totalLessons => _totalLessons;

  int get learningMinutes => _learningMinutes;

  int get xp => _xp;

  int get coins => _coins;

  int get stars => _stars;

  int get level => _level;

  double get completionPercentage => _completionPercentage;

  List<String> get completedLessonIds =>
      List.unmodifiable(_completedLessonIds);

  List<Map<String, dynamic>> get badges =>
      List.unmodifiable(_badges);

  // ============================================================
  // CURRENT PARENT
  // ============================================================

  User? get currentUser => _supabase.auth.currentUser;

  String? get parentId => currentUser?.id;

  // ============================================================
  // LOAD DASHBOARD
  // ============================================================

  Future<void> load() async {
    _setLoading(true);
    _error = null;

    try {
      final user = _supabase.auth.currentUser;

      if (user == null) {
        _error = 'Maatii galmaa\'e hin argamne.';
        return;
      }

      // --------------------------------------------------------
      // Find the child connected to this parent.
      //
      // Expected table:
      //
      // parent_student
      //
      // parent_id
      // student_id
      // --------------------------------------------------------

      final relationship = await _supabase
          .from('parent_student')
          .select('student_id')
          .eq('parent_id', user.id)
          .maybeSingle();

      if (relationship == null) {
        _error =
            'Barataan maatii kana waliin walqabate hin argamne.';
        return;
      }

      _studentId =
          relationship['student_id']?.toString();

      if (_studentId == null || _studentId!.isEmpty) {
        _error = 'Student ID hin argamne.';
        return;
      }

      await _loadStudentProfile();

      await _loadProgress();

      await _loadRewards();

      await _loadBadges();

      _calculateCompletion();
    } catch (e) {
      debugPrint(
        'Parent dashboard load error: $e',
      );

      _error =
          'Daashboordii maatii fe\'uu hin dandeenye.';
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // LOAD STUDENT PROFILE
  // ============================================================

  Future<void> _loadStudentProfile() async {
    if (_studentId == null) return;

    final profile = await _supabase
        .from('profiles')
        .select(
          'id, full_name, email, role, avatar_url',
        )
        .eq(
          'id',
          _studentId!,
        )
        .maybeSingle();

    if (profile == null) return;

    _studentName =
        profile['full_name']?.toString() ??
            'Barataa Afaan Koo';

    _studentAvatar =
        profile['avatar_url']?.toString();
  }

  // ============================================================
  // LOAD PROGRESS
  // ============================================================

  Future<void> _loadProgress() async {
    if (_studentId == null) return;

    _completedLessonIds.clear();

    final rows = await _supabase
        .from('progress')
        .select(
          'lesson_id, progress, completed',
        )
        .eq(
          'user_id',
          _studentId!,
        );

    int completed = 0;

    double totalProgress = 0;

    for (final row in rows) {
      final lessonId =
          row['lesson_id']?.toString();

      final value = _toDouble(
        row['progress'],
      );

      final isCompleted =
          row['completed'] == true ||
          value >= 1;

      if (lessonId != null) {
        if (!_completedLessonIds.contains(lessonId) &&
            isCompleted) {
          _completedLessonIds.add(lessonId);
        }
      }

      if (isCompleted) {
        completed++;
      }

      totalProgress += value;
    }

    _completedLessons = completed;

    _totalLessons = rows.length;

    if (rows.isNotEmpty) {
      _completionPercentage =
          totalProgress / rows.length;
    } else {
      _completionPercentage = 0;
    }
  }

  // ============================================================
  // LOAD REWARDS
  // ============================================================

  Future<void> _loadRewards() async {
    if (_studentId == null) return;

    final reward = await _supabase
        .from('rewards')
        .select(
          'xp, coins, stars, lessons_completed, games_completed',
        )
        .eq(
          'user_id',
          _studentId!,
        )
        .maybeSingle();

    if (reward == null) {
      _xp = 0;
      _coins = 0;
      _stars = 0;
      _level = 1;
      return;
    }

    _xp = _toInt(
      reward['xp'],
    );

    _coins = _toInt(
      reward['coins'],
    );

    _stars = _toInt(
      reward['stars'],
    );

    final calculatedLevel =
        (_xp ~/ 100) + 1;

    _level = calculatedLevel < 1
        ? 1
        : calculatedLevel;

    final cloudLessons =
        _toInt(
      reward['lessons_completed'],
    );

    if (cloudLessons > _completedLessons) {
      _completedLessons = cloudLessons;
    }
  }

  // ============================================================
  // LOAD BADGES
  // ============================================================

  Future<void> _loadBadges() async {
    if (_studentId == null) return;

    _badges.clear();

    try {
      final rows = await _supabase
          .from('student_badges')
          .select()
          .eq(
            'student_id',
            _studentId!,
          );

      for (final row in rows) {
        _badges.add(
          Map<String, dynamic>.from(row),
        );
      }
    } catch (e) {
      // Badges should not prevent the entire
      // parent dashboard from loading.
      debugPrint(
        'Parent badge load error: $e',
      );
    }
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refresh() async {
    await load();
  }

  // ============================================================
  // HELPERS
  // ============================================================

  int _toInt(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value.toString(),
        ) ??
        0;
  }

  double _toDouble(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value.toString(),
        ) ??
        0;
  }

  void _calculateCompletion() {
    if (_totalLessons <= 0) {
      return;
    }

    _completionPercentage =
        _completionPercentage.clamp(
      0.0,
      1.0,
    );
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ============================================================
  // CLEAR
  // ============================================================

  void clear() {
    _studentId = null;

    _studentName =
        'Barataa Afaan Koo';

    _studentAvatar = null;

    _completedLessons = 0;

    _totalLessons = 0;

    _learningMinutes = 0;

    _xp = 0;

    _coins = 0;

    _stars = 0;

    _level = 1;

    _completionPercentage = 0;

    _completedLessonIds.clear();

    _badges.clear();

    _error = null;

    notifyListeners();
  }
}