import 'dart:convert';

import 'package:homefe/api/api_client.dart';
import 'package:homefe/podo/answer/answer_body.dart';
import 'package:homefe/podo/login/login_body.dart';
import 'package:homefe/podo/question/question_body.dart';
import 'package:homefe/podo/refreshtoken/refresh_token_body.dart';
import 'package:homefe/podo/rss/news_items.dart';
import 'package:homefe/podo/rss/rss_sites.dart';
import 'package:homefe/podo/token/token.dart';
import 'package:logger/logger.dart';

class ApiRepository {
  ApiClient client;

  ApiRepository({required this.client});

  Future<Token?> login(LoginBody loginBody) async {
    const clientId =
        '75247409848-7gdm1b0i5d9kuaeumco7n5ov00ojevlg.apps.googleusercontent.com';
    const clientSecret = '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';
    Map<String, dynamic> data = {
      'username': loginBody.username,
      'password': loginBody.password,
      'grant_type': loginBody.grantType,
      'client_id': clientId,
      'client_secret': clientSecret,
    };

    try {
      List<Future<dynamic>> futures = [];
      futures.add(
        client.post('/auth', parameters: {"code": "123"}, data: data),
      );
      List<dynamic> results = await Future.wait(futures);

      if (results.isNotEmpty) {
        return Token(
          results.first.data,
          'token_type',
          'refresh_token',
          0,
          'scope',
        );
      }
    } catch (e) {
      Logger().e('Error during login: $e');
    }

    return null;
  }

  /// NOT VERIFIED BECAUSE OAUTH IS NOT USED (YET)
  Future<Token?> refreshLogin(RefreshTokenBody refreshTokenBody) async {
    const clientId =
        '75247409848-0fu1932smoiih7vrrhcqn5jqv3s0bago.apps.googleusercontent.com';
    const clientSecret = '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';
    Map<String, dynamic> data = {
      'grant_type': refreshTokenBody.grantType,
      'refresh_token': refreshTokenBody.refreshToken,
      'client_id': clientId,
      'client_secret': clientSecret,
    };

    try {
      List<Future<dynamic>> futures = [];
      futures.add(
        client.post('/auth', parameters: {"code": "123"}, data: data),
      );
      List<dynamic> results = await Future.wait(futures);

      if (results.isNotEmpty) {
        return Token(
          results.first.data,
          'token_type',
          'refresh_token',
          0,
          'scope',
        );
      }
    } catch (e) {
      Logger().e('Error refreshing token: $e');
    }

    return null;
  }

  Future<RssSites?> sites() async {
    List<Future<dynamic>> futures = [];
    futures.add(client.get('/sites', parameters: {"code": "123"}));
    List<dynamic> results = await Future.wait(futures);

    if (results.isNotEmpty) {
      Map<String, dynamic> json = jsonDecode(results.first.data);
      return RssSites.fromJson(json);
    }

    return null;
  }

  Future<NewsItems?> archive({int offset = 0, int limit = 10}) async {
    List<Future<dynamic>> futures = [];
    futures.add(
      client.get(
        '/archive',
        parameters: {"code": "123", "offset": offset, "limit": limit},
      ),
    );
    List<dynamic> results = await Future.wait(futures);

    if (results.isNotEmpty) {
      /// NOTE BACKEND RETURN TYPE DOES NOT NEED DECODING
      return NewsItems.fromJson(results.first.data);
    }

    return null;
  }

  Future<NewsItems?> search({required String query}) async {
    List<Future<dynamic>> futures = [];
    futures.add(client.get('/search', parameters: {"code": "123", "q": query}));
    List<dynamic> results = await Future.wait(futures);

    if (results.isNotEmpty) {
      return NewsItems.fromJson(results.first.data);
    }

    return null;
  }

  Future<(int, String)> refresh() async {
    List<Future<dynamic>> futures = [];
    futures.add(client.get('/refresh', parameters: {"code": "123"}));
    List<dynamic> results = await Future.wait(futures);

    if (results.isNotEmpty) {
      int returnCode = results.first.statusCode;
      String data = results.first.data.toString();
      return (returnCode, data);
    }

    return (500, 'Unknown error');
  }

  Future<AnswerBody?> answerToQuestion(QuestionBody questionBody) =>
      client.answerToQuestion(questionBody);
}
