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

  Future<Token> postLogin(LoginBody loginBody) => client.loginUser(loginBody);

  Future<Token> postRefresh(RefreshTokenBody refreshTokenBody) =>
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
