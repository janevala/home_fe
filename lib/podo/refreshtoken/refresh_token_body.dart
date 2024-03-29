// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_body.g.dart';

@JsonSerializable()
class RefreshTokenBody {
  @JsonKey(name: 'grant_type')
  String grantType;
  @JsonKey(name: 'refresh_token')
  String refreshToken;

//RefreshTokenBody('refresh_token', refreshToken)
  RefreshTokenBody(this.grantType, this.refreshToken);

  factory RefreshTokenBody.fromJson(Map<String, dynamic> json) => _$RefreshTokenBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenBodyToJson(this);

  @override
  String toString() {
    return 'RefreshTokenBody{grantType: $grantType, refreshToken: $refreshToken}';
  }

  String tokenString() {
    return 'grant_type=$grantType&refresh_token=$refreshToken';
  }
}
