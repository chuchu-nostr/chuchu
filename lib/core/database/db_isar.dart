import 'dart:async';
import 'package:isar/isar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// Conditional import for dart:io classes
import 'dart:io' if (dart.library.html) 'package:chuchu/core/account/platform_stub.dart';
import 'package:path_provider/path_provider.dart';

import '../account/model/relayDB_isar.dart';
import '../account/model/userDB_isar.dart';
import '../account/model/zapRecordsDB_isar.dart';
import '../account/model/zapsDB_isar.dart';
import '../config/configDB_isar.dart';
import '../feed/model/noteDB_isar.dart';
import '../feed/model/notificationDB_isar.dart';
import '../messages/model/messageDB_isar.dart';
import '../network/eventDB_isar.dart';
import '../relayGroups/model/groupDB_isar.dart';
import '../relayGroups/model/joinRequestDB_isar.dart';
import '../relayGroups/model/moderationDB_isar.dart';
import '../relayGroups/model/relayGroupDB_isar.dart';
import '../wallet/model/wallet_info.dart';
import '../wallet/model/wallet_transaction.dart';
import '../wallet/model/wallet_invoice.dart';

class DBISAR {
  static final DBISAR sharedInstance = DBISAR._internal();
  DBISAR._internal();
  factory DBISAR() => sharedInstance;

  late Isar isar;

  final Map<Type, List<dynamic>> _buffers = {};

  static bool _isarInitialized = false;
  Timer? _timer;

  List<IsarGeneratedSchema> schemas = [
    MessageDBISARSchema,
    UserDBISARSchema,
    RelayDBISARSchema,
    ZapRecordsDBISARSchema,
    ZapsDBISARSchema,
    GroupDBISARSchema,
    JoinRequestDBISARSchema,
    ModerationDBISARSchema,
    RelayGroupDBISARSchema,
    NoteDBISARSchema,
    NotificationDBISARSchema,
    ConfigDBISARSchema,
    EventDBISARSchema,
    WalletInfoSchema,
    WalletTransactionSchema,
    WalletInvoiceSchema,
  ];

  Future open(String pubkey) async {
    if (pubkey.isEmpty) {
      throw ArgumentError('pubkey cannot be empty');
    }
    
    if (kIsWeb) {
      // On web platform, Isar uses IndexedDB and doesn't need a directory
      print(() => 'DBISAR open: web platform, pubkey: $pubkey');
      if (!_isarInitialized) {
        await Isar.initialize();
        _isarInitialized = true;
      }
      final webDirectory = 'isar_$pubkey';
      try {
        isar = await Isar.open(
          schemas: schemas,
          directory: webDirectory,
          name: pubkey,
          engine: IsarEngine.sqlite,
        );
      } on IsarError catch (e) {
        // Handle schema mismatch errors
        if (e.toString().contains('Schema error') || 
            e.toString().contains('Could not deserialize existing schema')) {
          print(() => 'Schema error detected on web, clearing IndexedDB and retrying: $e');
          // On web, we can't directly delete IndexedDB, so we use a different name
          // or fall back to in-memory database
          try {
            // Try with a new name (adding timestamp to force new database)
            final newWebDirectory = '${webDirectory}_${DateTime.now().millisecondsSinceEpoch}';
            isar = await Isar.open(
              schemas: schemas,
              directory: newWebDirectory,
              name: pubkey,
              engine: IsarEngine.sqlite,
            );
            print(() => 'Successfully opened new database with directory: $newWebDirectory');
          } catch (e2) {
            // Final fallback to in-memory instance
            print(() => 'Failed to open new database, falling back to in-memory: $e2');
            isar = await Isar.open(
              schemas: schemas,
              directory: Isar.sqliteInMemory,
              name: pubkey,
              engine: IsarEngine.sqlite,
            );
          }
        } else {
          // Fallback to in-memory instance for other errors (e.g. private browsing or missing OPFS)
          print(() => 'Isar web open failed with $e. Falling back to in-memory database.');
          isar = await Isar.open(
            schemas: schemas,
            directory: Isar.sqliteInMemory,
            name: pubkey,
            engine: IsarEngine.sqlite,
          );
        }
      }
    } else {
      bool isOS = Platform.isIOS || Platform.isMacOS;
      // Type cast needed because of conditional import
      dynamic dir = isOS ? await getLibraryDirectory() : await getApplicationDocumentsDirectory();
      Directory directory = dir as Directory;
      var dbPath = directory.path;
      
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      
      print(() => 'DBISAR open: $dbPath, pubkey: $pubkey');
      try {
        isar = await Isar.open(
          schemas: schemas,
          directory: dbPath,
          name: pubkey,
        );
      } on IsarError catch (e) {
        // Handle schema mismatch errors by deleting old database and recreating
        if (e.toString().contains('Schema error') || 
            e.toString().contains('Could not deserialize existing schema')) {
          print(() => 'Schema error detected, deleting old database and recreating: $e');
          await _deleteDatabaseFiles(directory, pubkey);
          // Retry opening the database after deletion
          isar = await Isar.open(
            schemas: schemas,
            directory: dbPath,
            name: pubkey,
          );
        } else {
          // Re-throw other errors
          rethrow;
        }
      }
    }
  }

  Map<Type, List<dynamic>> getBuffers() {
    return Map.from(_buffers);
  }

  Future<void> saveObjectsToDB<T>(List<T> objects) async {
    for (var object in objects) {
      await saveToDB(object);
    }
  }

  Future<void> saveToDB<T>(T object) async {
    final type = T;
    if (!_buffers.containsKey(type)) {
      _buffers[type] = <T>[];
    }
    _buffers[type]!.add(object);

    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 200), () async {
      await _putAll();
    });
  }

  Future<void> _putAll() async {
    _timer?.cancel();
    _timer = null;

    if (_buffers.isEmpty) return;

    final Map<Type, List<dynamic>> typeMap = Map.from(_buffers);
    _buffers.clear();

    // Regardless of platform, ensure writes happen synchronously within
    // the transaction callback to keep Isar's write txn active.
    await isar.write((isar) {
      for (var type in typeMap.keys) {
        _saveTOISARSync(typeMap[type]!, type, isar);
      }
    });
  }

  // Synchronous version for web platform
  void _saveTOISARSync(List<dynamic> objects, Type type, Isar isar) {
    // All operations must be synchronous within the write transaction on web
    if (type == MessageDBISAR) {
      isar.messageDBISARs.putAll(objects.cast<MessageDBISAR>());
    } else if (type == UserDBISAR) {
      isar.userDBISARs.putAll(objects.cast<UserDBISAR>());
    } else if (type == RelayDBISAR) {
      isar.relayDBISARs.putAll(objects.cast<RelayDBISAR>());
    } else if (type == ZapRecordsDBISAR) {
      isar.zapRecordsDBISARs.putAll(objects.cast<ZapRecordsDBISAR>());
    } else if (type == ZapsDBISAR) {
      isar.zapsDBISARs.putAll(objects.cast<ZapsDBISAR>());
    } else if (type == GroupDBISAR) {
      isar.groupDBISARs.putAll(objects.cast<GroupDBISAR>());
    } else if (type == JoinRequestDBISAR) {
      isar.joinRequestDBISARs.putAll(objects.cast<JoinRequestDBISAR>());
    } else if (type == ModerationDBISAR) {
      isar.moderationDBISARs.putAll(objects.cast<ModerationDBISAR>());
    } else if (type == RelayGroupDBISAR) {
      isar.relayGroupDBISARs.putAll(objects.cast<RelayGroupDBISAR>());
    } else if (type == NoteDBISAR) {
      isar.noteDBISARs.putAll(objects.cast<NoteDBISAR>());
    } else if (type == NotificationDBISAR) {
      isar.notificationDBISARs.putAll(objects.cast<NotificationDBISAR>());
    } else if (type == ConfigDBISAR) {
      isar.configDBISARs.putAll(objects.cast<ConfigDBISAR>());
    } else if (type == EventDBISAR) {
      isar.eventDBISARs.putAll(objects.cast<EventDBISAR>());
    } else if (type == WalletInfo) {
      isar.walletInfos.putAll(objects.cast<WalletInfo>());
    } else if (type == WalletTransaction) {
      isar.walletTransactions.putAll(objects.cast<WalletTransaction>());
    } else if (type == WalletInvoice) {
      isar.walletInvoices.putAll(objects.cast<WalletInvoice>());
    }
  }

  /// Delete all database files for a given pubkey
  Future<void> _deleteDatabaseFiles(Directory directory, String pubkey) async {
    try {
      // Isar database files: {name}.isar and {name}.isar.lock
      final dbFile = File('${directory.path}/$pubkey.isar');
      final lockFile = File('${directory.path}/$pubkey.isar.lock');
      
      if (await dbFile.exists()) {
        await dbFile.delete();
        print(() => 'Deleted database file: ${dbFile.path}');
      }
      
      if (await lockFile.exists()) {
        await lockFile.delete();
        print(() => 'Deleted lock file: ${lockFile.path}');
      }
    } catch (e) {
      print(() => 'Error deleting database files: $e');
    }
  }

  Future<void> closeDatabase() async {
    _buffers.clear();
    _timer?.cancel();
    _timer = null;
    if (isar.isOpen) await isar.close();
  }
}
