// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsItem _$NewsItemFromJson(Map<String, dynamic> json) => NewsItem(
  json['title'] as String,
  json['description'] as String,
  json['link'] as String,
  json['published'] as String,
  json['content'] as String?,
  json['publishedParsed'] as String?,
  json['source'] as String?,
  json['linkImage'] as String?,
);

Map<String, dynamic> _$NewsItemToJson(NewsItem instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'content': instance.content,
  'link': instance.link,
  'published': instance.published,
  'publishedParsed': instance.publishedParsed,
  'source': instance.source,
  'linkImage': instance.linkImage,
};
