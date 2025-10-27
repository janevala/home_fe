import 'package:homefe/api/api_client.dart';
import 'package:homefe/podo/answer/answer_body.dart';
import 'package:homefe/podo/login/login_body.dart';
import 'package:homefe/podo/question/question_body.dart';
import 'package:homefe/podo/refreshtoken/refresh_token_body.dart';
import 'package:homefe/podo/rss/news_items.dart';
import 'package:homefe/podo/rss/rss_sites.dart';
import 'package:homefe/podo/token/token.dart';

class ApiRepository {
  ApiClient apiClient;

  ApiRepository({required this.apiClient});

  ApiClient get client => apiClient;

  Future<Token> postLogin(LoginBody loginBody) =>
      apiClient.loginUser(loginBody);

  Future<Token> postRefresh(RefreshTokenBody refreshTokenBody) =>
      apiClient.refreshAuth(refreshTokenBody);

  Future<RssSites> getSites() => apiClient.getSites();

  Future<NewsItems?> getArchive({int offset = 0, int limit = 10}) =>
      apiClient.getArchive(offset: offset, limit: limit);

  Future<AnswerBody?> answerToQuestion(QuestionBody questionBody) =>
      apiClient.answerToQuestion(questionBody);
}
