import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:webfeed/domain/rss_feed.dart';

abstract class BaseClient {
  final Dio dio;

  BaseClient(this.dio);

  @protected
  Future<Response<dynamic>> get(
    String uri, {
    Map<String, dynamic> parameters = const {},
  }) async {
    try {
      Response<dynamic> response = await _get(uri, parameters: parameters);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @protected
  Future<Response<dynamic>> post(
    String uri, {
    Map<String, dynamic> parameters = const {},
    Map<String, dynamic> data = const {},
  }) async {
    try {
      Response<dynamic> response = await _post(
        uri,
        parameters: parameters,
        data: data,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @protected
  Future<Response<dynamic>> put(
    String uri, {
    Map<String, dynamic> parameters = const {},
    Map<String, dynamic> data = const {},
  }) async {
    try {
      Response<dynamic> response = await _put(
        uri,
        parameters: parameters,
        data: data,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @protected
  Future<Response<dynamic>> delete(
    String uri, {
    Map<String, dynamic> parameters = const {},
  }) async {
    try {
      Response<dynamic> response = await _delete(uri, parameters: parameters);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<dynamic>> _get(
    String uri, {
    Map<String, dynamic> parameters = const {},
  }) async {
    try {
      Response<dynamic> response = await dio.get(
        uri,
        queryParameters: parameters,
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception("Error code ${response.statusCode}");
      }
    } on SocketException {
      throw Exception("Internet connection problem");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<dynamic>> _post(
    String uri, {
    Map<String, dynamic> parameters = const {},
    Map<String, dynamic> data = const {},
  }) async {
    try {
      Response<dynamic> response = await dio.post(
        uri,
        queryParameters: parameters,
        data: data,
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception("Error code ${response.statusCode}");
      }
    } on SocketException {
      throw Exception("Internet connection problem");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<dynamic>> _put(
    String uri, {
    Map<String, dynamic> parameters = const {},
    Map<String, dynamic> data = const {},
  }) async {
    try {
      Response<dynamic> response = await dio.put(
        uri,
        queryParameters: parameters,
        data: data,
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Error code ${response.statusCode}");
      }
    } on SocketException {
      throw Exception("Internet connection problem");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<dynamic>> _delete(
    String uri, {
    Map<String, dynamic> parameters = const {},
  }) async {
    try {
      Response<dynamic> response = await dio.delete(
        uri,
        queryParameters: parameters,
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Error code ${response.statusCode}");
      }
    } on SocketException {
      throw Exception("Internet connection problem");
    } catch (e) {
      rethrow;
    }
  }
}
