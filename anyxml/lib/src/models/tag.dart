import 'dart:convert';

enum TagArgType { str, map }

class Tag {
  String? startAnnotation, endAnnotation; // ? ! --
  String type; // type of tag
  Map<String, dynamic>? args;
  String? argStr;
  bool isDirectClosing, isClosing;

  Tag({this.startAnnotation, required this.type, this.args, this.argStr,
    this.endAnnotation, required this.isDirectClosing, required this.isClosing});

  TagArgType argType() {
    if (args != null) {
      if (argStr != null) {
        throw Exception('Only one arg type should have been initiated');
      }
      return TagArgType.map;
    } else if (argStr != null) {
      if (args != null) {
        throw Exception('Only one arg type should have been initiated');
      }
      return TagArgType.str;
    } else {
      throw Exception('One arg type should have been initiated');
    }
  }

  String compile() {
    if ((argStr != null && argStr!.isNotEmpty) && (args != null && args!.isNotEmpty)) {
      throw Exception('argStr and args cannot be used at the same time');
    }
    String str = '<';
    if (startAnnotation != null && startAnnotation!.isNotEmpty) {
      if (isClosing) {
        throw Exception('Closing with start annotation is invalid');
      }
      str += startAnnotation!;
    } else if (isClosing) {
      if (isDirectClosing) {
        throw Exception('Closing as well direct closing is invalid');
      }
      str += '/';
    }
    if (type != 'comment') {
      str += type;
    }
    if (argStr != null && argStr!.isNotEmpty) {
      str += ' $argStr';
      if (type == 'comment') {
        str += ' ';
      }
    } else if (args != null && args!.isNotEmpty) {
      str += ' ';
      final keys = args!.keys;
      for (final key in keys) {
        String data = args![key];
        if (data.contains('"')) {
          if (data.contains("'")) {
            throw Exception('Escape not implemented!');
          }
          str += "$key='$data' ";
        } else if (data.contains("'")) {
          if (data.contains('"')) {
            throw Exception('Escape not implemented!');
          }
          str += '$key="$data" ';
        } else {
          str += '$key="$data" ';
        }
      }
      str = str.substring(0, str.length - 1);
    }
    if (endAnnotation != null && endAnnotation!.isNotEmpty) {
      if (isDirectClosing) {
        throw Exception('Direct closing with end annotation is invalid');
      }
      str += endAnnotation!;
    } else if (isDirectClosing) {
      str += '/';
    }
    str += '>';
    return str;
  }

  Map<String, dynamic> toJson() {
    return {
      'startAnnotation': startAnnotation,
      'endAnnotation': endAnnotation,
      'type': type,
      'args': args == null ? null : jsonEncode(args),
      'argStr': argStr,
      'isClosing': isClosing,
      'isDirectClosing': isDirectClosing
    };
  }

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      startAnnotation: json['startAnnotation'],
      endAnnotation: json['endAnnotation'],
      type: json['type']!,
      args: json['args'] == null ? null : json['args'].runtimeType == String ? jsonDecode(json['args']!) : json['args'],
      argStr: json['argStr'],
      isClosing: json['isClosing'] == 'true' ? true : false,
      isDirectClosing: json['isDirectClosing'] == 'true' ? true : false,
    );
  }
}

class ParsedTag {
  Tag tag;
  int startIndex, afterIndex;
  ParsedTag(this.tag, this.startIndex, this.afterIndex);
}