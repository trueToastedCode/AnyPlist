import 'dart:convert';
import "dart:html" as html;

import 'safe_data_contract.dart';

class SafeDataWeb implements ISafeData {
  @override
  void safe(String data, String filename) {
    // prepare
    final bytes = utf8.encode(data);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = filename;
    html.document.body?.children.add(anchor);
    // download
    anchor.click();
    // cleanup
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}