import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/dfareporting/v4.dart' as common;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../services/google_auth.dart';

final _googleSignIn =
    GoogleSignIn.standard(scopes: [drive.DriveApi.driveAppdataScope]);

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  Future<GoogleSignInAccount?> _getGoogleAccount() async {
    try {
      final account = await _googleSignIn.signIn();
      return account;
    } catch (error) {
      return null;
    }
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    final account = await _getGoogleAccount();
    if (account == null) {
      return null;
    }

    final headers = await account.authHeaders;
    final client = GoogleAuthClient(headers);
    final driveApi = drive.DriveApi(client);
    return driveApi;
  }

  void _backup(BuildContext context) async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) {
      return;
    }

    // Get database path
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "data.db");
    var dbFile = File(path);
    if (!dbFile.existsSync()) {
      return;
    }

    // Upload file
    final file = drive.File()
      ..name = "data.db"
      ..parents = ["appDataFolder"];
    await driveApi.files.create(file,
        uploadMedia: drive.Media(dbFile.openRead(), dbFile.lengthSync()));

    if (context.mounted) {
      _showResult(context, 'Database uploaded to Drive!');
    }
  }

  void _restore(BuildContext context) async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) {
      return;
    }

    // Search for database file
    final files = await driveApi.files.list(
      spaces: "appDataFolder",
      q: "name = 'data.db'",
    );
    if (files.files == null || files.files!.isEmpty) {
      if (context.mounted) {
        _showResult(context, 'Database not found!');
      }
      return;
    }

    // Get database path
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "data.db");
    var dbFile = File(path);

    // Download file
    final fileId = files.files!.first.id;
    final response = await driveApi.files.get(fileId!,
        downloadOptions: drive.DownloadOptions.fullMedia) as common.Media;
    final stream = dbFile.openWrite();
    response.stream.pipe(stream);

    if (context.mounted) {
      _showResult(context, 'Database restored from Drive!');
    }

    // Cleanup
    await stream.flush();
    await stream.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 10,
                  child: ElevatedButton(
                    onPressed: () => _backup(context),
                    child: const Text(
                      'Backup DB',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 10,
                  child: ElevatedButton(
                    onPressed: () => _restore(context),
                    child: const Text(
                      'Restore DB',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showResult(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }
}
