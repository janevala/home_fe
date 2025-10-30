import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:homefe/api/base_client.dart';
import 'package:homefe/api/logging_interceptor.dart';
import 'package:homefe/podo/answer/answer_body.dart';
import 'package:homefe/podo/question/question_body.dart';

class ApiClient extends BaseClient {
  ApiClient(String baseUrl)
    : super(
        Dio()
          ..options.baseUrl = baseUrl
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

  Future<AnswerBody?> answerToQuestion(QuestionBody question) async {
    try {
      final response = await dio.post(
        '/explain',
        queryParameters: {"code": "123"},
        data: {'question': question.question},
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.data);
        return AnswerBody.fromJson(json);
      } else {
        return AnswerBody.withError('Error code ${response.statusCode}');
      }
    } catch (error, _) {
      debugPrint(error.toString());

      return AnswerBody.withError('$error');
    }
  }
}
