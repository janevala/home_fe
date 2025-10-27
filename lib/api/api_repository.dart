import 'package:homefe/api/api_client.dart';
import 'package:homefe/podo/answer/answer_body.dart';
import 'package:homefe/podo/login/login_body.dart';
import 'package:homefe/podo/question/question_body.dart';
import 'package:homefe/podo/refreshtoken/refresh_token_body.dart';
import 'package:homefe/podo/rss/news_items.dart';
import 'package:homefe/podo/rss/rss_sites.dart';
import 'package:homefe/podo/token/token.dart';
import 'package:webfeed/webfeed.dart';

class ApiRepository {
  ApiClient apiClient;

  ApiRepository({required this.apiClient});

  Future<Token> postLogin(LoginBody loginBody) =>
      apiClient.loginUser(loginBody);

  Future<Token> postRefresh(RefreshTokenBody refreshTokenBody) =>
      apiClient.refreshAuth(refreshTokenBody);

  Future<RssSites> getSites() => apiClient.getSites();

  Future<NewsItems?> getArchive({int offset = 0, int limit = 10}) =>
      apiClient.getArchive(offset: offset, limit: limit);

  Future<AnswerBody?> answerToQuestion(QuestionBody questionBody) =>
      apiClient.answerToQuestion(questionBody);

  // TODO: switch to use apiClient like the rest
  Future<RssFeed?> getRss(Uri uri) {
    return ApiClient.rss('${uri.scheme}://${uri.host}').getRss(uri.path);
  }
}
