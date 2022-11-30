// import 'dart:js_util';
// import 'package:js/js.dart';

import 'package:anyplist/services/adblock_detection/adblock_detection_contract.dart';

// @JS()
// external detectAdblock();

class AdblockDetection implements IAdblockDetection {
  @override
  Future<bool> isBocked() async {
    // final promise = detectAdblock();
    // return await promiseToFuture(promise);
    return false;
  }
}