// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemoryStats _$MemoryStatsFromJson(Map<String, dynamic> json) => MemoryStats(
      (json['Alloc'] as num).toInt(),
      (json['NumGC'] as num).toInt(),
      (json['PauseEnd'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      (json['PauseNs'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      (json['PauseTotalNs'] as num).toInt(),
      (json['Sys'] as num).toInt(),
      (json['TotalAlloc'] as num).toInt(),
    );

Map<String, dynamic> _$MemoryStatsToJson(MemoryStats instance) =>
    <String, dynamic>{
      'Alloc': instance.alloc,
      'NumGC': instance.numGC,
      'PauseEnd': instance.pauseEnd,
      'PauseNs': instance.pauseNs,
      'PauseTotalNs': instance.pauseTotalNs,
      'Sys': instance.sys,
      'TotalAlloc': instance.totalAlloc,
    };
