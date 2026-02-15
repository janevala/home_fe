// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HttpStats _$HttpStatsFromJson(Map<String, dynamic> json) => HttpStats(
  json['AvgResponseTime'] as String,
  Map<String, int>.from(json['RequestsByMethod'] as Map),
  Map<String, int>.from(json['ResponseCodeCount'] as Map),
  (json['TotalRequests'] as num).toInt(),
  json['TotalResponseTime'] as String,
);

Map<String, dynamic> _$HttpStatsToJson(HttpStats instance) => <String, dynamic>{
  'AvgResponseTime': instance.avgResponseTime,
  'RequestsByMethod': instance.requestsByMethod,
  'ResponseCodeCount': instance.responseCodeCount,
  'TotalRequests': instance.totalRequests,
  'TotalResponseTime': instance.totalResponseTime,
};
