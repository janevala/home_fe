import 'package:homefe/api/api_client.dart';
import 'package:homefe/podo/login/login_body.dart';
import 'package:homefe/podo/refreshtoken/refresh_token_body.dart';
import 'package:homefe/podo/rss/rss_json_feed.dart';
import 'package:homefe/podo/rss/rss_sites.dart';
import 'package:homefe/podo/token/token.dart';
import 'package:webfeed/webfeed.dart';

class ApiRepository {
  final ApiClient client = ApiClient();

  Future<Token> postLogin(LoginBody loginBody) => client.loginUser(loginBody);

  Future<Token> postRefresh(RefreshTokenBody refreshTokenBody) =>
      client.refreshAuth(refreshTokenBody);

  Future<RssSites> getSites() => client.getSites();

  Future<List<RssJsonFeed>> getArchive() => client.getArchive();

  Future<RssFeed?> getRss(Uri uri) {
    return ApiClient.rss('${uri.scheme}://${uri.host}').getRss(uri.path);
  }
}
