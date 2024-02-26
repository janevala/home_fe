// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'token.g.dart';

@JsonSerializable()
class Token {
  @JsonKey(name: 'access_token')
  late String accessToken;
  @JsonKey(name: 'token_type')
  late String tokenType;
  @JsonKey(name: 'refresh_token')
  late String refreshToken;
  @JsonKey(name: 'expires_in')
  late int expiresIn;
  late String scope;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String error = '';

  Token(this.accessToken, this.tokenType, this.refreshToken, this.expiresIn, this.scope);

  Token.withError(this.error);

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  Map<String, dynamic> toJson() => _$TokenToJson(this);

  @override
  String toString() {
    return 'Token{accessToken: $accessToken, tokenType: $tokenType, refreshToken: $refreshToken, expiresIn: $expiresIn, scope: $scope}';
  }
}
