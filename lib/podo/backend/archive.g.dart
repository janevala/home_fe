// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArchiveStats _$ArchiveStatsFromJson(Map<String, dynamic> json) => ArchiveStats(
  json['status'] as String,
  (json['count'] as num).toInt(),
  json['oldest'] as String,
);

Map<String, dynamic> _$ArchiveStatsToJson(ArchiveStats instance) =>
    <String, dynamic>{
      'status': instance.status,
      'count': instance.count,
      'oldest': instance.oldest,
    };
