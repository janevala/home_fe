// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rss_sites.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RssSites _$RssSitesFromJson(Map<String, dynamic> json) => RssSites(
      json['time'] as int,
      json['title'] as String,
      (json['sites'] as List<dynamic>)
          .map((e) => RssSite.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RssSitesToJson(RssSites instance) => <String, dynamic>{
      'time': instance.time,
      'title': instance.title,
      'sites': instance.sites,
    };
