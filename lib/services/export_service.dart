import 'dart:convert';
import 'dart:io';
import 'backup_service.dart';
import 'journal_service.dart';

/// Service layer that coordinates backup/restore operations between
/// BackupService and JournalService, providing better separation of concerns.
class ExportService {
  final JournalService _journalService;
  final BackupService _backupService;

  ExportService({
    required JournalService journalService,
    BackupService? backupService,
  })  : _journalService = journalService,
        _backupService = backupService ?? BackupService();

  /// Exports journal data and shares it
  Future<void> exportData(String password) async {
    final journalData = await _journalService.exportData();
    await _backupService.exportJournal(journalData, password);
  }

  /// Exports journal data to a local file chosen by the user
  Future<String?> exportDataToLocal(String password) async {
    final journalData = await _journalService.exportData();
    return await _backupService.saveJournalLocally(journalData, password);
  }

  /// Imports journal data from an encrypted backup file
  Future<Map<String, dynamic>> importData(
    String password,
    String filePath,
  ) async {
    final result = await _backupService.importJournal(password, filePath);
    final data = result['data'] as Map<String, dynamic>;
    final metadata = result['metadata'] as Map<String, dynamic>;

    // Validate the imported data structure
    _backupService.validateJournalData(data);

    return {'data': data, 'metadata': metadata};
  }

  /// Imports legacy (unencrypted) journal data
  Future<Map<String, dynamic>> importLegacyData(String jsonString) async {
    final data = json.decode(jsonString) as Map<String, dynamic>;

    // Validate the imported data structure
    _backupService.validateJournalData(data);

    return {'data': data, 'metadata': {}};
  }

  /// Detects whether a backup file is encrypted or legacy (unencrypted) format
  Future<bool> isEncryptedBackup(String filePath) async {
    // First check file extension
    if (filePath.endsWith('.fjb')) {
      return true; // .fjb files are encrypted
    }

    // If extension doesn't tell us, check the content structure
    try {
      final file = File(filePath);
      final content = await file.readAsString();
      final parsed = json.decode(content) as Map<String, dynamic>;

      // Encrypted backups have 'metadata' and 'data' with 'content', 'iv', 'salt'
      if (parsed.containsKey('metadata') && parsed.containsKey('data')) {
        final data = parsed['data'] as Map<String, dynamic>;
        return data.containsKey('content') &&
            data.containsKey('iv') &&
            data.containsKey('salt');
      }

      return false; // Doesn't match encrypted format
    } catch (_) {
      // If we can't parse it, assume it's encrypted and let import handle the error
      return true;
    }
  }

  /// Smart import that automatically detects backup format
  Future<Map<String, dynamic>> importDataAuto(
    String password,
    String filePath,
  ) async {
    final isEncrypted = await isEncryptedBackup(filePath);

    if (isEncrypted) {
      return await importData(password, filePath);
    } else {
      // Legacy unencrypted format
      final file = File(filePath);
      final content = await file.readAsString();
      return await importLegacyData(content);
    }
  }
}
