// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'rss_site.g.dart';

@JsonSerializable()
class RssSite {
  @JsonKey(name: 'Uuid')
  late String uuid;
  @JsonKey(name: 'Title')
  late String title;
  @JsonKey(name: 'Url')
  late String url;

  RssSite(this.title, this.url);

  factory RssSite.fromJson(Map<String, dynamic> json) =>
      _$RssSiteFromJson(json);

  Map<String, dynamic> toJson() => _$RssSiteToJson(this);
}
