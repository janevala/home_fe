import 'package:json_annotation/json_annotation.dart';

part 'news_item.g.dart';

@JsonSerializable()
class NewsItem {
  @JsonKey(name: 'id')
  late int id;
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
  @JsonKey(name: 'llm')
  late String? llm;
  @JsonKey(name: 'language')
  late String? language;

  NewsItem(
    this.id,
    this.title,
    this.description,
    this.link,
    this.published, [
    this.content,
    this.publishedParsed,
    this.source,
    this.linkImage,
    this.llm,
    this.language,
  ]);

  factory NewsItem.fromJson(Map<String, dynamic> json) => _$NewsItemFromJson(json);

  Map<String, dynamic> toJson() => _$NewsItemToJson(this);
}
