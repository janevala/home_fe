import 'package:homefe/api/api_client.dart';
import 'package:homefe/podo/login/login_body.dart';
import 'package:homefe/podo/refreshtoken/refresh_token_body.dart';
import 'package:homefe/podo/rss/rss_json_feed.dart';
import 'package:homefe/podo/rss/rss_sites.dart';
import 'package:homefe/podo/token/token.dart';
import 'package:webfeed/webfeed.dart';

class ApiRepository {
  final ApiClient apiClient = ApiClient();

  Future<Token> postLogin(LoginBody loginBody) =>
      apiClient.loginUser(loginBody);

  Future<Token> postRefresh(RefreshTokenBody refreshTokenBody) =>
      apiClient.refreshAuth(refreshTokenBody);

  Future<RssSites> getRssSites() =>
      apiClient.getRssSites();
  
  Future<List<RssJsonFeed>> getRssAggregateFeeds() =>
      apiClient.getRssAggregate();

  Future<RssFeed?> getRss(Uri uri) {
    return ApiClient.rss('${uri.scheme}://${uri.host}').getRssFeed(uri.path);
  }
}
