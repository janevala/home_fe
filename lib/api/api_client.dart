import 'package:dio/dio.dart';
import 'package:homefe/api/api_client_base.dart';
import 'package:homefe/api/logging_interceptor.dart';

class ApiClient extends BaseClient {
  ApiClient(String baseUrl)
    : super(
        Dio()
          ..options.baseUrl = baseUrl
          ..options.connectTimeout = Duration(minutes: 3)
          ..options.receiveTimeout = Duration(minutes: 3)
          ..interceptors.add(LoggingInterceptor()),
      );

  @override
  Future<Response<dynamic>> get(
    String uri, {
    Map<String, dynamic> parameters = const {},
  }) {
    return super.get(uri, parameters: parameters);
  }

  @override
  Future<Response<dynamic>> post(
    String uri, {
    Map<String, dynamic> parameters = const {},
    Map<String, dynamic> data = const {},
  }) {
    return super.post(uri, parameters: parameters, data: data);
  }

  @override
  Future<Response<dynamic>> put(
    String uri, {
    Map<String, dynamic> parameters = const {},
    Map<String, dynamic> data = const {},
  }) {
    return super.put(uri, parameters: parameters, data: data);
  }

  @override
  Future<Response<dynamic>> delete(
    String uri, {
    Map<String, dynamic> parameters = const {},
  }) {
    return super.delete(uri, parameters: parameters);
  }
}
