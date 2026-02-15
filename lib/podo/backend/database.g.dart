// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DatabaseStats _$DatabaseStatsFromJson(Map<String, dynamic> json) =>
    DatabaseStats(
      (json['Idle'] as num).toInt(),
      (json['InUse'] as num).toInt(),
      (json['MaxIdleClosed'] as num).toInt(),
      (json['MaxIdleTimeClosed'] as num).toInt(),
      (json['MaxLifetimeClosed'] as num).toInt(),
      (json['MaxOpenConnections'] as num).toInt(),
      (json['OpenConnections'] as num).toInt(),
      (json['WaitCount'] as num).toInt(),
      json['WaitDuration'] as String,
    );

Map<String, dynamic> _$DatabaseStatsToJson(DatabaseStats instance) =>
    <String, dynamic>{
      'Idle': instance.idle,
      'InUse': instance.inUse,
      'MaxIdleClosed': instance.maxIdleClosed,
      'MaxIdleTimeClosed': instance.maxIdleTimeClosed,
      'MaxLifetimeClosed': instance.maxLifetimeClosed,
      'MaxOpenConnections': instance.maxOpenConnections,
      'OpenConnections': instance.openConnections,
      'WaitCount': instance.waitCount,
      'WaitDuration': instance.waitDuration,
    };
