import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataContext {
  DataContext._();

  static final DataContext instance = DataContext._();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "data.db");

    if (!await databaseExists(path)) {
      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      final data = await rootBundle.load(url.join("assets", "db", "data.db"));
      final bytes = data.buffer.asUint8List();

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes);
    }

    return await openDatabase(
      path,
      version: 1,
      onUpgrade: (database, oldVersion, newVersion) async {
        for (var i = oldVersion; i < newVersion; i++) {
          String script = await _loadMigrationScript(i);

          // Extract individual commands as sqflite does not support executing multiple commands
          final commands = script
              .split(";")
              .map((cmd) => cmd.trim())
              .where((cmd) => cmd.isNotEmpty);

          // Execute
          for (var cmd in commands) {
            await database.execute(cmd);
          }
        }
      },
    );
  }

  Future<String> _loadMigrationScript(int version) async {
    return await rootBundle.loadString(url.join(
        "assets", "migrations", "migration_v${version}_${version + 1}.sql"));
  }
}
