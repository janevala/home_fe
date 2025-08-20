// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rss_sites.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RssSites _$RssSitesFromJson(Map<String, dynamic> json) => RssSites(
      (json['Time'] as num).toInt(),
      json['Title'] as String,
      (json['Sites'] as List<dynamic>)
          .map((e) => RssSite.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RssSitesToJson(RssSites instance) => <String, dynamic>{
      'Time': instance.time,
      'Title': instance.title,
      'Sites': instance.sites,
    };
