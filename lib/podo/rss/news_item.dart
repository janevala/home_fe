// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'news_item.g.dart';

@JsonSerializable()
class NewsItem {
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
  @JsonKey(name: 'source')
  late String? source;
  @JsonKey(name: 'linkImage')
  late String? linkImage;

  NewsItem(this.title, this.description, this.link, this.published,
      [this.content, this.publishedParsed, this.source, this.linkImage]);

  factory NewsItem.fromJson(Map<String, dynamic> json) =>
      _$NewsItemFromJson(json);

  Map<String, dynamic> toJson() => _$NewsItemToJson(this);
}
