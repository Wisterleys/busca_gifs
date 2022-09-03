import 'dart:ffi';

import 'package:flutter/foundation.dart';

@immutable
abstract class HttpClientModel {
  const HttpClientModel();
  
  Future<dynamic> request({
   required String url,
   required String method,
   Map<String, dynamic> body,
   Map? headers
  });
}