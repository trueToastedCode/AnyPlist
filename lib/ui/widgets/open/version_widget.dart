import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionWidget extends StatefulWidget {
  const VersionWidget({Key? key}) : super(key: key);

  @override
  State<VersionWidget> createState() => _VersionWidgetState();
}

class _VersionWidgetState extends State<VersionWidget> {
  PackageInfo? _packageInfo;

  @override
  initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _packageInfo == null ? '' : 'v${_packageInfo!.version}',
      style: const TextStyle(color: Colors.white70),
    );
  }

  _init() {
    PackageInfo.fromPlatform().then((packageInfo) => setState(() => _packageInfo = packageInfo));
  }
}
