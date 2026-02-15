// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) => Config(
  json['os'] as String,
  json['arch'] as String,
  json['version'] as String,
  json['go_version'] as String,
  (json['num_cpu'] as num).toInt(),
  (json['num_goroutine'] as num).toInt(),
  (json['num_gomaxprocs'] as num).toInt(),
  (json['num_cgo_call'] as num).toInt(),
);

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
  'os': instance.os,
  'arch': instance.arch,
  'version': instance.version,
  'go_version': instance.goVersion,
  'num_cpu': instance.numCpu,
  'num_goroutine': instance.numGoroutine,
  'num_gomaxprocs': instance.numGomaxprocs,
  'num_cgo_call': instance.numCgoCall,
};
