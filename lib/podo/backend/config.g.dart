// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) => Config(
  json['uptime'] as String,
  json['os'] as String,
  json['arch'] as String,
  json['version'] as String,
  json['go_version'] as String,
  (json['num_cpu'] as num).toInt(),
  (json['num_goroutine'] as num).toInt(),
  (json['num_gomaxprocs'] as num).toInt(),
  (json['num_cgo_call'] as num).toInt(),
  DatabaseStats.fromJson(json['db_stats'] as Map<String, dynamic>),
  HttpStats.fromJson(json['http_stats'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
  'uptime': instance.uptime,
  'os': instance.os,
  'arch': instance.arch,
  'version': instance.version,
  'go_version': instance.goVersion,
  'num_cpu': instance.numCpu,
  'num_goroutine': instance.numGoroutine,
  'num_gomaxprocs': instance.numGomaxprocs,
  'num_cgo_call': instance.numCgoCall,
  'db_stats': instance.dbStats,
  'http_stats': instance.httpStats,
};
