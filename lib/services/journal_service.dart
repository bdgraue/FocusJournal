import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class JournalEntry {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime lastModified;

  JournalEntry({
    String? id,
    required this.content,
    DateTime? createdAt,
    DateTime? lastModified,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: DateTime.parse(json['lastModified'] as String),
    );
  }

  JournalEntry copyWith({
    String? content,
  }) {
    return JournalEntry(
      id: id,
      content: content ?? this.content,
      createdAt: createdAt,
      lastModified: DateTime.now(),
    );
  }
}

class JournalService {
  static const String _storageKey = 'journal_entries';
  final SharedPreferences _prefs;

  JournalService._({required SharedPreferences prefs}) : _prefs = prefs;

  static Future<JournalService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return JournalService._(prefs: prefs);
  }

  Future<List<JournalEntry>> getAllEntries() async {
    final jsonString = _prefs.getString(_storageKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => JournalEntry.fromJson(json))
          .toList()
          ..sort((a, b) => b.lastModified.compareTo(a.lastModified));
    } catch (e) {
      print('Error loading journal entries: $e');
      return [];
    }
  }

  Future<void> saveEntries(List<JournalEntry> entries) async {
    final jsonList = entries.map((entry) => entry.toJson()).toList();
    await _prefs.setString(_storageKey, json.encode(jsonList));
  }

  Future<void> addEntry(JournalEntry entry) async {
    final entries = await getAllEntries();
    entries.add(entry);
    await saveEntries(entries);
  }

  Future<void> updateEntry(JournalEntry updatedEntry) async {
    final entries = await getAllEntries();
    final index = entries.indexWhere((e) => e.id == updatedEntry.id);
    if (index != -1) {
      entries[index] = updatedEntry;
      await saveEntries(entries);
    }
  }

  Future<void> deleteEntry(String id) async {
    final entries = await getAllEntries();
    entries.removeWhere((e) => e.id == id);
    await saveEntries(entries);
  }

  Future<Map<String, dynamic>> exportData() async {
    final entries = await getAllEntries();
    return {
      'entries': entries.map((e) => e.toJson()).toList(),
      'metadata': {
        'version': '1.0',
        'exportDate': DateTime.now().toIso8601String(),
        'entryCount': entries.length,
      },
    };
  }

  Future<void> importData(Map<String, dynamic> data) async {
    try {
      final entriesList = (data['entries'] as List<dynamic>)
          .map((json) => JournalEntry.fromJson(json as Map<String, dynamic>))
          .toList();
      await saveEntries(entriesList);
    } catch (e) {
      throw Exception('Invalid journal data format: $e');
    }
  }
}