// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'rss_json_feed.g.dart';

@JsonSerializable()
class RssJsonFeed {
  @JsonKey(name: 'title')
  late String title;
  @JsonKey(name: 'description')
  late String description;
  @JsonKey(name: 'content')
  late String? content;
  @JsonKey(name: 'link')
  late String link;
  @JsonKey(name: 'published')
  late String published;
  @JsonKey(name: 'publishedParsed')
  late String? publishedParsed;
  @JsonKey(name: 'updated') // news source, field reused because backend guy lazy TODO
  late String? source;
  @JsonKey(name: 'linkImage')
  late String? linkImage;

  RssJsonFeed(this.title, this.description, this.link, this.published, [this.content, this.publishedParsed, this.source, this.linkImage]);

  factory RssJsonFeed.fromJson(Map<String, dynamic> json) => _$RssJsonFeedFromJson(json);

  Map<String, dynamic> toJson() => _$RssJsonFeedToJson(this);
}
