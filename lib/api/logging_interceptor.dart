import 'package:dio/dio.dart';
import 'package:homefe/logger/logger.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.i(
      'onRequest | ${options.method} | ${options.uri} | ${options.data}',
    );

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    logger.i('onResponse | ${response.statusCode} | ${response.statusMessage}');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e('onError | ${err.response?.statusCode} | ${err.response?.data}');

    super.onError(err, handler);
  }
}
