// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rss_site.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RssSite _$RssSiteFromJson(Map<String, dynamic> json) => RssSite(
      json['title'] as String,
      json['url'] as String,
    )..uuid = json['uuid'] as String;

Map<String, dynamic> _$RssSiteToJson(RssSite instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'title': instance.title,
      'url': instance.url,
    };
