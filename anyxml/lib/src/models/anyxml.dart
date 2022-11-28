import 'dart:convert';

import "package:hex/hex.dart";

import '../../anyxml.dart';

class AnyXML {
  List<dynamic> get anyXML => _anyXML;
  final List<dynamic> _anyXML;

  static final _regExpDate = RegExp(r'[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])T(2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]Z');

  AnyXML([List<dynamic> anyXML = const []]) : _anyXML = anyXML;

  String compile() {
    return _compile(anyXML, 0);
  }

  String _compile(List<dynamic> entry, int indent) {
    if (entry.isEmpty) return '';
    String str = '';
    final space = '\t' * indent;
    for (final item in entry) {
      switch (item['type']) {
        case 'plist':
        case 'dict':
        case 'array':
          final tag = Tag.fromJson(item);
          tag.isDirectClosing = false;
          str += '$space${tag.compile()}\n';
          str += _compile(item['content'], item['type'] == 'plist' ? indent : indent + 1);
          str += '$space</${item['type']}>\n';
          break;
        case 'key':
          final tag = Tag.fromJson(item);
          if (item['content'].isEmpty) {
            throw Exception('Key has not content');
          }
          tag.isDirectClosing = false;
          str += '$space${tag.compile()}${item['key']}</key>\n';
          str += _compile([item['content']], indent);
          break;
        case 'string':
        case 'integer':
        case 'data':
        case 'date':
          final tag = Tag.fromJson(item);
          tag.isDirectClosing = false;
          str += '$space${tag.compile()}${item['content']}</${item['type']}>\n';
          break;
        case 'bool':
          String compiled;
          switch (item['content']) {
            case 'false':
              compiled = '<false/>';
              break;
            case 'true':
              compiled = '<true/>';
              break;
            default:
              throw Exception('Invalid bool content');
          }
          str += '$space$compiled\n';
          break;
        case 'other':
          final tag = Tag.fromJson(item['content']);
          str += '$space${tag.compile()}\n';
          break;
        default:
          throw Exception('Undefined type: "${item['type']}"');
      }
    }
    return str;
  }

  int findType(List<dynamic> entry, String type) {
    if (entry.isNotEmpty) {
      for (int i=0; i<entry.length; i++) {
        if (entry[i]['type'] == type) {
          return i;
        }
      }
    }
    return -1;
  }

  void convert(List<dynamic> path, String newType) {
    if (path.isEmpty) return;
    final element = getPath(path);
    final type = element['type'];
    if (type.runtimeType != String || type == null || type.isEmpty) {
      throw Exception('Undefined type');
    }
    Map<String, dynamic> newElement;
    switch (type) {
      case 'dict':
        switch (newType) {
          case 'dict':
            newElement = element;
            break;
          case 'array':
            newElement = {'type': 'array', 'args': null, 'content': []};
            break;
          case 'string':
            newElement = {'type': 'string', 'args': null, 'content': ''};
            break;
          case 'integer':
            newElement = {'type': 'integer', 'args': null, 'content': ''};
            break;
          case 'data':
            newElement = {'type': 'data', 'args': null, 'content': ''};
            break;
          case 'bool':
            newElement = {'type': 'bool', 'args': null, 'content': 'false'};
            break;
          case 'date':
            newElement = {'type': 'date', 'args': null, 'content': ''};
            break;
          default:
            throw Exception('Undefined new type');
        }
        break;
      case 'array':
        switch (newType) {
          case 'dict':
            newElement = {'type': 'dict', 'args': null, 'content': []};
            break;
          case 'array':
            newElement = element;
            break;
          case 'string':
            newElement = {'type': 'string', 'args': null, 'content': ''};
            break;
          case 'integer':
            newElement = {'type': 'integer', 'args': null, 'content': ''};
            break;
          case 'data':
            newElement = {'type': 'data', 'args': null, 'content': ''};
            break;
          case 'bool':
            newElement = {'type': 'bool', 'args': null, 'content': 'false'};
            break;
          case 'date':
            newElement = {'type': 'date', 'args': null, 'content': ''};
            break;
          default:
            throw Exception('Undefined new type');
        }
        break;
      case 'string':
        switch (newType) {
          case 'dict':
            newElement = {'type': 'dict', 'args': null, 'content': []};
            break;
          case 'array':
            newElement = {'type': 'array', 'args': null, 'content': []};
            break;
          case 'string':
            newElement = element;
            break;
          case 'integer':
            newElement = {'type': 'integer', 'args': null, 'content': '${int.tryParse(element['content']) ?? 0}'};
            break;
          case 'data':
            String content;
            try {
              content = element['content'].length == 0 ? '' : base64.encode(HEX.decode(element['content']));
            } on Exception {
              content = '';
            }
            newElement = {'type': 'data', 'args': null, 'content': content};
            break;
          case 'bool':
            newElement = {'type': 'bool', 'args': null, 'content': ['false', 'true'].contains(element['content']) ? element['content'] : 'false'};
            break;
          case 'date':
            newElement = {'type': 'date', 'args': null, 'content': _regExpDate.hasMatch(element['content']) ? element['content'] : ''};
            break;
          default:
            throw Exception('Undefined new type');
        }
        break;
      case 'integer':
        switch (newType) {
          case 'dict':
            newElement = {'type': 'dict', 'args': null, 'content': []};
            break;
          case 'array':
            newElement = {'type': 'array', 'args': null, 'content': []};
            break;
          case 'string':
            newElement = {'type': 'string', 'args': null, 'content': element['content']};
            break;
          case 'integer':
            newElement = element;
            break;
          case 'data':
            newElement = {'type': 'data', 'args': null, 'content': element['content'].length == 0 ? '' : base64.encode(HEX.decode(int.parse(element['content']).toRadixString(16)))};
            break;
          case 'bool':
            newElement = {'type': 'bool', 'args': null, 'content': element['content'].length == 0 ? 'false' : int.parse(element['content']) > 0 ? 'true' : 'false'};
            break;
          case 'date':
            newElement = {'type': 'date', 'args': null, 'content': ''};
            break;
          default:
            throw Exception('Undefined new type');
        }
        break;
      case 'data':
        switch (newType) {
          case 'dict':
            newElement = {'type': 'dict', 'args': null, 'content': []};
            break;
          case 'array':
            newElement = {'type': 'array', 'args': null, 'content': []};
            break;
          case 'string':
            newElement = {'type': 'string', 'args': null, 'content': element['content'].length == 0 ? '' : HEX.encode(base64.decode(element['content']))};
            break;
          case 'integer':
            newElement = {'type': 'integer', 'args': null, 'content': element['content'].length == 0 ? '' : '${int.parse(HEX.encode(base64.decode(element['content'])), radix: 16)}'};
            break;
          case 'data':
            newElement = element;
            break;
          case 'bool':
            newElement = {'type': 'bool', 'args': null, 'content': 'false'};
            break;
          case 'date':
            newElement = {'type': 'date', 'args': null, 'content': ''};
            break;
          default:
            throw Exception('Undefined new type');
        }
        break;
      case 'bool':
        switch (newType) {
          case 'dict':
            newElement = {'type': 'dict', 'args': null, 'content': []};
            break;
          case 'array':
            newElement = {'type': 'array', 'args': null, 'content': []};
            break;
          case 'string':
            newElement = {'type': 'string', 'args': null, 'content': element['content'] == 'false' ? 'false' : 'true'};
            break;
          case 'integer':
            newElement = {'type': 'integer', 'args': null, 'content': ''};
            break;
          case 'data':
            newElement = {'type': 'data', 'args': null, 'content': ''};
            break;
          case 'bool':
            newElement = element;
            break;
          case 'date':
            newElement = {'type': 'date', 'args': null, 'content': ''};
            break;
          default:
            throw Exception('Undefined new type');
        }
        break;
      case 'date':
        switch (newType) {
          case 'dict':
            newElement = {'type': 'dict', 'args': null, 'content': []};
            break;
          case 'array':
            newElement = {'type': 'array', 'args': null, 'content': []};
            break;
          case 'string':
            newElement = {'type': 'string', 'args': null, 'content': element['content']};
            break;
          case 'integer':
            newElement = {'type': 'integer', 'args': null, 'content': ''};
            break;
          case 'data':
            newElement = {'type': 'data', 'args': null, 'content': ''};
            break;
          case 'bool':
            newElement = {'type': 'bool', 'args': null, 'content': 'false'};
            break;
          case 'date':
            newElement = element;
            break;
          default:
            throw Exception('Undefined new type');
        }
        break;
      default:
        throw Exception('Undefined type');
    }
    setPath(path, newElement);
  }

  void reorder(List<dynamic> path, int from, int to) {
    if (from == to) return;
    final list = getPath(path);
    if (list is! List) {
      throw Exception('Expected path to point at list');
    } else if (list.isEmpty) {
      throw Exception('List is empty');
    } else if (from < 0 || from >= list.length) {
      throw Exception('From is not in range');
    } else if (to < 0 || to >= list.length) {
      throw Exception('To is not in range');
    }
    final item = list[from];
    list.removeAt(from);
    list.insert(to, item);
    setPath(path, list);
  }

  void setPath(List<dynamic> path, dynamic value) {
    if (path.isNotEmpty && _anyXML.isNotEmpty) {
      final workPath = List<dynamic>.from(path);
      _setPath(null, workPath, value);
    }
  }

  void _setPath(dynamic entry, List<dynamic> path, dynamic value) {
    if (path.length == 1) {
      if (value == null) {
        _anyXML.removeAt(path.first);
      } else {
        _anyXML[path.first] = value;
      }
    } else {
      entry = getPath(List.from(path)..removeLast());
      if (value == null) {
        entry.removeAt(path.last);
      } else if (path.last.runtimeType == int && path.last >= entry.length) {
        entry.add(value);
      } else {
        entry[path.last] = value;
      }
      path.removeLast();
      _setPath(getPath(path), path, entry);
    }
  }

  dynamic getPath(List<dynamic> path) {
    return _getPath(_anyXML, path);
  }

  dynamic _getPath(dynamic entry, List<dynamic> path) {
    if (path.isEmpty) return entry;
    final element = path.first;
    if (element.runtimeType == int) {
      if (element < 0 || element > entry.length) {
        throw RangeError('Index out of range');
      } else if (path.length == 1) {
        return entry[element];
      } else {
        final nextPath = List<dynamic>.from(path);
        nextPath.removeAt(0);
        return _getPath(entry[element], nextPath);
      }
    } else if (element.runtimeType == String) {
      if (path.length == 1) {
        return entry[element];
      } else {
        final nextPath = List<dynamic>.from(path);
        nextPath.removeAt(0);
        return _getPath(entry[element], nextPath);
      }
    } else {
      throw Exception('Invalid runtimeType in path');
    }
  }
}