import 'package:anyplist/services/version_check/version_check_contract.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;


class VersionCheck implements IVersionCheck {
  static const _versionURL = 'https://raw.githubusercontent.com/trueToastedCode/AnyPlistRelease/main/version.txt';

  final _packageInfo = PackageInfo.fromPlatform();

  @override
  Future<bool> isNewerVersion() async {
    final url = Uri.parse(_versionURL);
    final response = await http.get(url);
    return _versionToNumber((await _packageInfo).version) < _versionToNumber(response.body);
  }

  int _versionToNumber(String version) {
    return int.parse(version.replaceAll('.', ''));
  }
}