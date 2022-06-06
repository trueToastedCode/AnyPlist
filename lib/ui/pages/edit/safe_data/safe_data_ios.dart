import 'dart:io';

import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';

import 'safe_data_contract.dart';

class SafeDataIOS implements ISafeData {
  @override
  void safe(String data, String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    if (await file.exists()) {
      await file.delete();
    }
    await file.create();
    file.writeAsStringSync(data);
    await FlutterShare.shareFile(
      title: filename,
      filePath: file.path,
    );
  }
}