// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'rss_site.g.dart';

@JsonSerializable()
class RssSite {
  @JsonKey(name: 'uuid')
  late String uuid;
  @JsonKey(name: 'title')
  late String title;
  @JsonKey(name: 'url')
  late String url;

  RssSite(this.title, this.url);

  factory RssSite.fromJson(Map<String, dynamic> json) => _$RssSiteFromJson(json);

  Map<String, dynamic> toJson() => _$RssSiteToJson(this);
}
