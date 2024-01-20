// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rss_json_feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RssJsonFeed _$RssJsonFeedFromJson(Map<String, dynamic> json) => RssJsonFeed(
      json['title'] as String,
      json['description'] as String,
      json['link'] as String,
      json['published'] as String,
      json['publishedParsed'] as String,
      json['content'] as String?,
    );

Map<String, dynamic> _$RssJsonFeedToJson(RssJsonFeed instance) {
  final val = <String, dynamic>{
    'title': instance.title,
    'description': instance.description,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('content', instance.content);
  val['link'] = instance.link;
  val['published'] = instance.published;
  val['publishedParsed'] = instance.publishedParsed;
  return val;
}
