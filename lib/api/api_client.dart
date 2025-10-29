import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:homefe/api/base_client.dart';
import 'package:homefe/api/logging_interceptor.dart';
import 'package:homefe/podo/answer/answer_body.dart';
import 'package:homefe/podo/login/login_body.dart';
import 'package:homefe/podo/question/question_body.dart';
import 'package:homefe/podo/refreshtoken/refresh_token_body.dart';
import 'package:homefe/podo/token/token.dart';
import 'package:webfeed/webfeed.dart';

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

  Future<Token> loginUser(LoginBody loginBody) async {
    const clientId =
        '75247409848-7gdm1b0i5d9kuaeumco7n5ov00ojevlg.apps.googleusercontent.com';
    const clientSecret = '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';

    try {
      final response = await dio.post(
        '/auth',
        queryParameters: {"code": "123"},
        data: {
          'username': loginBody.username,
          'password': loginBody.password,
          'grant_type': loginBody.grantType,
          'client_id': clientId,
          'client_secret': clientSecret,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        if (response.data == loginBody.username) {
          return Token(
            response.data,
            'token_type',
            'refresh_token',
            0,
            'scope',
          );
        } else {
          return Token.withError(response.data);
        }
      } else {
        return Token.withError('Error code ${response.statusCode}');
      }
    } catch (error, _) {
      debugPrint(error.toString());

      return Token.withError('$error');
    }
  }

  Future<Token> refreshAuth(RefreshTokenBody refreshTokenBody) async {
    const clientId =
        '75247409848-0fu1932smoiih7vrrhcqn5jqv3s0bago.apps.googleusercontent.com';
    const clientSecret = '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';

    try {
      final response = await dio.post(
        '/auth',
        queryParameters: {"code": "123"},
        data: {
          'grant_type': refreshTokenBody.grantType,
          'refresh_token': refreshTokenBody.refreshToken,
          'client_id': clientId,
          'client_secret': clientSecret,
        },
        options: Options(contentType: Headers.jsonContentType),
      );
      return Token.fromJson(response.data);
    } catch (error, _) {
      debugPrint(error.toString());

      return Token.withError('$error');
    }
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

  // ApiClient.ext();

  Future<RssFeed?> getRss(Uri uri) async {
    try {
      final Dio extDio = Dio();
      extDio.options.baseUrl = '${uri.scheme}://${uri.host}';
      final response = await extDio.get(uri.path);

      if (response.statusCode == 200) {
        return RssFeed.parse(response.data);
      }
    } catch (error, _) {
      debugPrint(error.toString());
    }

    return null;
  }
}
