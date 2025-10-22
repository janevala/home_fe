// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rss_site.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RssSite _$RssSiteFromJson(Map<String, dynamic> json) =>
    RssSite(json['Title'] as String, json['Url'] as String)
      ..uuid = json['Uuid'] as String;

Map<String, dynamic> _$RssSiteToJson(RssSite instance) => <String, dynamic>{
  'Uuid': instance.uuid,
  'Title': instance.title,
  'Url': instance.url,
};
