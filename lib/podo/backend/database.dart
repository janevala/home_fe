// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'database.g.dart';

@JsonSerializable()
class DatabaseStats {
  @JsonKey(name: 'Idle')
  late int idle;
  @JsonKey(name: 'InUse')
  late int inUse;
  @JsonKey(name: 'MaxIdleClosed')
  late int maxIdleClosed;
  @JsonKey(name: 'MaxIdleTimeClosed')
  late int maxIdleTimeClosed;
  @JsonKey(name: 'MaxLifetimeClosed')
  late int maxLifetimeClosed;
  @JsonKey(name: 'MaxOpenConnections')
  late int maxOpenConnections;
  @JsonKey(name: 'OpenConnections')
  late int openConnections;
  @JsonKey(name: 'WaitCount')
  late int waitCount;
  @JsonKey(name: 'WaitDuration')
  late String waitDuration;

  DatabaseStats(
    this.idle,
    this.inUse,
    this.maxIdleClosed,
    this.maxIdleTimeClosed,
    this.maxLifetimeClosed,
    this.maxOpenConnections,
    this.openConnections,
    this.waitCount,
    this.waitDuration,
  );

  factory DatabaseStats.fromJson(Map<String, dynamic> json) =>
      _$DatabaseStatsFromJson(json);

  Map<String, dynamic> toJson() => _$DatabaseStatsToJson(this);
}
