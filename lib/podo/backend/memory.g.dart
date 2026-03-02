// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemoryStats _$MemoryStatsFromJson(Map<String, dynamic> json) => MemoryStats(
  json['Alloc'] as String,
  (json['BySize'] as List<dynamic>)
      .map((e) => BySize.fromJson(e as Map<String, dynamic>))
      .toList(),
  json['NumGC'] as String,
  (json['PauseEnd'] as List<dynamic>).map((e) => e as String).toList(),
  (json['PauseNs'] as List<dynamic>).map((e) => e as String).toList(),
  json['PauseTotalNs'] as String,
  json['Sys'] as String,
  json['TotalAlloc'] as String,
);

Map<String, dynamic> _$MemoryStatsToJson(MemoryStats instance) =>
    <String, dynamic>{
      'Alloc': instance.alloc,
      'BySize': instance.bySize,
      'NumGC': instance.numGC,
      'PauseEnd': instance.pauseEnd,
      'PauseNs': instance.pauseNs,
      'PauseTotalNs': instance.pauseTotalNs,
      'Sys': instance.sys,
      'TotalAlloc': instance.totalAlloc,
    };
