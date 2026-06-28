import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/journal.dart';

class JournalProvider extends ChangeNotifier {
  late Box<Journal> _box;
  List<Journal> _journals = [];
  String _searchQuery = '';

  List<Journal> get journals => _filteredJournals;
  List<Journal> get allJournals => _journals;
  String get searchQuery => _searchQuery;

  List<Journal> get _filteredJournals {
    if (_searchQuery.isEmpty) return _journals;
    return _journals.where((j) {
      return j.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          j.location.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Future<void> init() async {
    _box = Hive.box<Journal>(AppBoxes.journals);
    _loadJournals();
  }

  void _loadJournals() {
    _journals = _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> addJournal(Journal journal) async {
    await _box.put(journal.id, journal);
    _loadJournals();
  }

  Future<void> updateJournal(Journal journal) async {
    await _box.put(journal.id, journal);
    _loadJournals();
  }

  Future<void> deleteJournal(String id) async {
    await _box.delete(id);
    _loadJournals();
  }

  Journal? getJournalById(String id) {
    return _box.get(id);
  }

  // Stats
  int get totalJournals => _journals.length;

  int get totalPhotos => _journals
      .where((j) => j.imagePath != null && j.imagePath!.isNotEmpty)
      .length;

  int get activeMonths {
    if (_journals.isEmpty) return 0;
    final months = _journals
        .map((j) => '${j.travelDate.year}-${j.travelDate.month}')
        .toSet();
    return months.length;
  }

  Map<String, int> get journalsByMonth {
    final Map<String, int> result = {};
    for (final journal in _journals) {
      final key =
          '${journal.travelDate.year}-${journal.travelDate.month.toString().padLeft(2, '0')}';
      result[key] = (result[key] ?? 0) + 1;
    }
    return result;
  }
}

class AppBoxes {
  static const String journals = 'journals';
}
