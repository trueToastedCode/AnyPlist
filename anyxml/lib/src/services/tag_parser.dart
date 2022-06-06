import '../models/tag.dart';

class TagParser {
  int _argStr(String data, int start) {
    int i = start;
    while (i < data.length) {
      if (data[i] == '>') {
        return i;
      } else if (data[i] == '"') {
        i = data.indexOf('"', i + 1);
        if (i == -1) {
          throw Exception('Declared tab with arguments that have string area that never ends');
        }
      } else if (data[i] == "'") {
        i = data.indexOf("'", i + 1);
        if (i == -1) {
          throw Exception('Declared tab with arguments that have string area that never ends');
        }
      }
      i++;
    }
    return -1;
  }

  static const _validArgCharacters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.';

  Map<String, String> _parseArgs(String argStr) {
    Map<String, String> args = {};
    if (argStr.isEmpty) {
      return args;
    }
    int i = 0, start = 0;
    while (i < argStr.length) {
      if (!_validArgCharacters.contains(argStr[i])) {
        if (i == 0) {
          // invalid argument schema
          throw Exception('Invalid argument schema');
        } else if (argStr[i] == '=') {
          if (argStr[i + 1] == '"') {
            final stop = argStr.indexOf('"', i + 2);
            if (stop == -1) {
              throw Exception('Invalid argument schema: Missing closing string mark');
            }
            args[argStr.substring(start, i)] = argStr.substring(i + 2, stop);
            i = stop + 1;
            if (i >= argStr.length) {
              return args;
            }
            if (argStr[i] != ' ') {
              throw Exception('Invalid argument schema: Expected end or space after string closing mark');
            }
            i++;
            while (i < argStr.length && argStr[i] == ' ') {
              i++;
            }
            if (i >= argStr.length) {
              return args;
            }
            start = i;
            continue;
          } else if (argStr[i + 1] == "'") {
            final stop = argStr.indexOf("'", i + 2);
            if (stop == -1) {
              throw Exception('Invalid argument schema: Missing closing string mark');
            }
            args[argStr.substring(start, i)] = argStr.substring(i + 2, stop);
            i = stop + 1;
            if (i >= argStr.length) {
              return args;
            }
            if (argStr[i] != ' ') {
              throw Exception('Invalid argument schema: Expected end or space after string closing mark');
            }
            i++;
            while (i < argStr.length && argStr[i] == ' ') {
              i++;
            }
            if (i >= argStr.length) {
              return args;
            }
            start = i;
            continue;
          }
        } else {
          // invalid argument schema
          throw Exception('Invalid argument schema');
        }
      }
      i++;
    }
    return args;
  }

  ParsedTag? nextTag(String data, int pStart) {
    // find start and stop of opening tag and args
    final start = data.indexOf('<', pStart);
    if (start == -1) {
      // opening tag not found
      return null;
    }
    int i = start + 1, stop = -1, argsStart = -1;
    while (i < data.length) {
      if (data[i] == ' ') {
        // tag has args
        argsStart = i + 1;
        stop = _argStr(data, argsStart);
        break;
      } else if (data[i] == '>') {
        // found ending of opening tag
        stop = i;
        break;
      }
      i++;
    }
    if (stop == -1) {
      // opening tag never stops
      throw Exception('Declared tag opening but i never ends');
    }
    // split opening tag into type and args
    String type;
    String argStr = '';
    if (argsStart == -1) {
      type = data.substring(start + 1, stop).trim();
    } else {
      type = data.substring(start + 1, argsStart).trim();
      argStr = data.substring(argsStart, stop).trim();
    }
    if (type.isEmpty) {
      // type not declared
      throw Exception('Declared tag opening but not declared type');
    }
    // acquire annotation/s
    switch(type[0]) {
      case '?':
        if (argStr.isNotEmpty && argStr[argStr.length - 1] == '?') {
          // <? ... ?>
          final filteredType = type.substring(1);
          if (filteredType.isEmpty) {
            throw Exception('Undeclared type of opening tag');
          }
          final args = _parseArgs(argStr.substring(0, argStr.length - 1));
          final tag = Tag(type: filteredType, args: args, startAnnotation: '?',
              endAnnotation: '?', isClosing: false, isDirectClosing: false);
          return ParsedTag(tag, start, stop + 1);
        } else {
          // expected ? at end
          throw Exception('Declared tag opening with ? annotation that is missing at end');
        }
      case '!':
        if (type.length - 1 >= 2 && argStr.length >= 3
            && type.substring(1, 3) == '--'
            && argStr.substring(argStr.length - 3, argStr.length) == '--!') {
          // <!-- ... --!>
          final tag = Tag(type: 'comment', startAnnotation: '!--', endAnnotation: '--!',
              argStr: argStr.substring(0, argStr.length - 3).trim(),
              isClosing: false, isDirectClosing: false);
          return ParsedTag(tag, start, stop + 1);
        } else {
          // <! ... >
          if (argStr.isNotEmpty && argStr[argStr.length - 1] == '!') {
            throw Exception('Invalid tag: starts with ! and with ! but is not a comment');
          }
          final filteredType = type.substring(1);
          if (filteredType.isEmpty) {
            throw Exception('Undeclared type of opening tag');
          }
          final tag = Tag(type: filteredType, startAnnotation: '!',
              argStr: argStr, isClosing: false, isDirectClosing: false);
          return ParsedTag(tag, start, stop + 1);
        }
      default:
        if (type[type.length - 1] == '/') {
          // < ... />
          if (argStr.isNotEmpty) {
            throw Exception('Invalid type: Seems to end directly but also has some argument data');
          }
          final filteredType = type.substring(0, type.length - 1);
          if (filteredType.isEmpty) {
            throw Exception('Undeclared type of opening tag');
          }
          Tag tag;
          if (filteredType == 'true' || filteredType == 'false') {
            tag = Tag(type: 'bool', argStr: filteredType, isClosing: true, isDirectClosing: true);
          } else {
            tag = Tag(type: filteredType, isClosing: true, isDirectClosing: true);
          }
          return ParsedTag(tag, start, stop + 1);
        } else if (type[0] == '/') {
          // </ ... >
          if (argStr.isNotEmpty) {
            throw Exception('Invalid type: Closing tag but also has some argument data');
          }
          final filteredType = type.substring(1);
          if (filteredType.isEmpty) {
            throw Exception('Undeclared type of closing tag');
          }
          final tag = Tag(type: filteredType, isClosing: true, isDirectClosing: false);
          return ParsedTag(tag, start, stop + 1);
        } else if (argStr.isNotEmpty && argStr[argStr.length - 1] == '/') {
          // < ... bla/>
          final args = _parseArgs(argStr.substring(0, argStr.length - 1));
          final tag = Tag(type: type, isClosing: true, isDirectClosing: true, args: args);
          return ParsedTag(tag, start, stop + 1);
        } else {
          // < ... >
          final args = _parseArgs(argStr);
          final tag = Tag(type: type, args: args, isClosing: false, isDirectClosing: false);
          return ParsedTag(tag, start, stop + 1);
        }
    }
  }
}