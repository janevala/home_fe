import 'dart:convert';

import 'package:homefe/api/api_client.dart';
import 'package:homefe/podo/answer/answer_body.dart';
import 'package:homefe/podo/backend/config.dart';
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
    const clientId = 'clientId';
    const clientSecret = 'clientSecret';
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
    const clientId = 'clientId';
    const clientSecret = 'clientSecret';
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

  Future<NewsItems?> archive({int offset = 0, int limit = 10, String? language}) async {
    Map<String, dynamic> parameters = {"code": "123", "offset": offset, "limit": limit};

    if (language != null) {
      parameters["lang"] = language;
    }

    List<Future<dynamic>> futures = [];
    futures.add(
      client.get(
        '/archive',
        parameters: parameters,
      ),
    );
    List<dynamic> results = await Future.wait(futures);

    if (results.isNotEmpty) {
      return NewsItems.fromJson(results.first.data);
    }

    return null;
  }

  Future<NewsItems?> search({required String query, String? language}) async {
    Map<String, dynamic> parameters = {"code": "123", "q": query};

    if (language != null) {
      parameters["lang"] = language;
    }

    List<Future<dynamic>> futures = [];
    futures.add(client.get('/search', parameters: parameters));
    List<dynamic> results = await Future.wait(futures);

    if (results.isNotEmpty) {
      return NewsItems.fromJson(results.first.data);
    }

    return null;
  }

  Future<(int, dynamic)> refresh() async {
    List<Future<dynamic>> futures = [];
    futures.add(client.get('/refresh', parameters: {"code": "123"}));
    List<dynamic> results = await Future.wait(futures);

    if (results.isNotEmpty) {
      int returnCode = results.first.statusCode;
      dynamic data = results.first.data;
      return (returnCode, data);
    }

    return (500, 'Unknown error');
  }

  Future<AnswerBody?> answerToQuestion(QuestionBody questionBody) async {
    Map<String, dynamic> data = {'question': questionBody.question};

    try {
      List<Future<dynamic>> futures = [];
      futures.add(
        client.post('/translate', parameters: {"code": "123"}, data: data),
      );
      List<dynamic> results = await Future.wait(futures);

      if (results.isNotEmpty) {
        return AnswerBody.fromJson(results.first.data);
      }
    } catch (e) {
      return AnswerBody.withError('Error: $e');
    }

    return null;
  }

  Future<Config?> getConfig() async {
    List<Future<dynamic>> futures = [];
    futures.add(client.get('/jq', parameters: {"code": "123"}));
    List<dynamic> results = await Future.wait(futures);

    if (results.isNotEmpty) {
      return Config.fromJson(results.first.data);
    }

    return null;
  }
}
