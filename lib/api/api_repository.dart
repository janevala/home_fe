import 'dart:convert';

import 'package:homefe/api/api_client.dart';
import 'package:homefe/podo/answer/answer_body.dart';
import 'package:homefe/podo/login/login_body.dart';
import 'package:homefe/podo/question/question_body.dart';
import 'package:homefe/podo/refreshtoken/refresh_token_body.dart';
import 'package:homefe/podo/rss/news_items.dart';
import 'package:homefe/podo/rss/rss_sites.dart';
import 'package:homefe/podo/token/token.dart';

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

    List<Future<dynamic>> futures = [];
    futures.add(client.post('/auth', parameters: {"code": "123"}, data: data));
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

    return null;
  }

  Future<Token> refreshLogin(RefreshTokenBody refreshTokenBody) =>
      client.refreshAuth(refreshTokenBody);

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

  Future<AnswerBody?> answerToQuestion(QuestionBody questionBody) =>
      client.answerToQuestion(questionBody);
}
