import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//    options.headers['Authorization'] = 'Bearer token';
    debugPrint(
        'onRequest  | ${options.method} | ${options.uri} | ${options.data}');

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    debugPrint('onResponse | ${response.statusCode} | ${response.data}');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('onError | ${err.response?.statusCode} | ${err.response?.data}');

    super.onError(err, handler);
  }
}
