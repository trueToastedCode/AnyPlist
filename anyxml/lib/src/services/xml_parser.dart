import 'package:anyxml/src/models/anyxml.dart';

import 'tag_parser.dart';
import '../models/tag.dart';

class XMLParser {
  AnyXML parseXML(String data) {
    final tagParser = TagParser();
    final result = _parseXML(data, null, false, 0, tagParser);
    AnyXML anyXML;
    if (result.isEmpty) {
      anyXML = AnyXML();
    } else {
      anyXML = AnyXML(result[0]);
    }
    if (anyXML.findType(anyXML.anyXML, 'plist') == -1) {
      throw Exception('Entry not found');
    }
    return anyXML;
  }

  List<dynamic> _parseXML(String data, String? parentType, bool one, int start,
      TagParser tagParser) {
    final list = <dynamic>[];
    if (data.isEmpty) {
      return list;
    }
    int brokenIndex = start;
    ParsedTag? parsedTag = tagParser.nextTag(data, brokenIndex);
    while (parsedTag != null) {
      switch (parsedTag.tag.type) {
        case 'dict':
        case 'array':
        case 'plist':
          if (parsedTag.tag.isDirectClosing) {
            list.add({
              'type': parsedTag.tag.type,
              'args': parsedTag.tag.args,
              'content': []
            });
            brokenIndex = parsedTag.afterIndex;
          } else if (parsedTag.tag.isClosing) {
            if (parentType != parsedTag.tag.type) {
              throw Exception('Unexpected closing tag');
            }
            return [list, parsedTag.afterIndex];
          } else {
            final result = _parseXML(data, parsedTag.tag.type, false,
                parsedTag.afterIndex, tagParser);
            list.add({
              'type': parsedTag.tag.type,
              'args': parsedTag.tag.args,
              'content': result[0]
            });
            brokenIndex = result[1];
          }
          break;
        case 'integer':
        case 'data':
        case 'string':
        case 'date':
          if (parsedTag.tag.isDirectClosing) {
            list.add({
              'type': parsedTag.tag.type,
              'args': parsedTag.tag.args,
              'content': ''
            });
            brokenIndex = parsedTag.afterIndex;
          } else {
            final nextTag = tagParser.nextTag(data, parsedTag.afterIndex);
            if (nextTag == null
                || (parsedTag.tag.type == 'string' && nextTag.tag.type != 'string')
                || (parsedTag.tag.type == 'data' && nextTag.tag.type != 'data')
                || !nextTag.tag.isClosing) {
              throw Exception('String tag never closes properly');
            }
            final content = data.substring(parsedTag.afterIndex, nextTag.startIndex);
            list.add({
              'type': parsedTag.tag.type,
              'args': parsedTag.tag.args,
              'content': content
            });
            brokenIndex = nextTag.afterIndex;
          }
          break;
        case 'bool':
          list.add({
            'type': parsedTag.tag.type,
            'content': parsedTag.tag.argStr
          });
          brokenIndex = parsedTag.afterIndex;
          break;
        case 'key':
          if (parentType != 'dict') {
            throw Exception('Unexpected key tag');
          }
          final nextTag = tagParser.nextTag(data, parsedTag.afterIndex);
          if (nextTag == null || nextTag.tag.type != 'key') {
            throw Exception('Key tag never closes properly');
          }
          final key = data.substring(parsedTag.afterIndex, nextTag.startIndex);
          if (key.isEmpty) {
            throw Exception('Key tag is missing a key');
          }
          final result = _parseXML(data, null, true, nextTag.afterIndex, tagParser);
          if (result[0][0]['type'] == 'key') {
            throw Exception('Key without a child');
          }
          list.add({
            'type': parsedTag.tag.type,
            'args': parsedTag.tag.args,
            'key': key,
            'content': result[0][0]
          });
          brokenIndex = result[1];
          break;
        default:
          list.add({
            'type': 'other',
            'content': parsedTag.tag.toJson()
          });
          brokenIndex = parsedTag.afterIndex;
      }
      if (one) {
        return [list, brokenIndex];
      } else if (brokenIndex >= data.length) {
        if (parentType != null) {
          throw Exception('Parent tag never closes');
        }
        return [list, data.length];
      }
      parsedTag = tagParser.nextTag(data, brokenIndex);
    }
    return [list, data.length];
  }
}