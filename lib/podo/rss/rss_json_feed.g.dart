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
      json['content'] as String?,
      json['publishedParsed'] as String?,
      json['updated'] as String?,
    );

Map<String, dynamic> _$RssJsonFeedToJson(RssJsonFeed instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'content': instance.content,
      'link': instance.link,
      'published': instance.published,
      'publishedParsed': instance.publishedParsed,
      'updated': instance.updated,
    };
