import 'package:homefe/podo/backend/by_size.dart';
import 'package:json_annotation/json_annotation.dart';

part 'memory.g.dart';

@JsonSerializable()
class MemoryStats {
  @JsonKey(name: 'Alloc')
  late String alloc;
  @JsonKey(name: 'BySize')
  late List<BySize> bySize;
  @JsonKey(name: 'NumGC')
  late String numGC;
  @JsonKey(name: 'PauseEnd')
  late List<String> pauseEnd;
  @JsonKey(name: 'PauseNs')
  late List<String> pauseNs;
  @JsonKey(name: 'PauseTotalNs')
  late String pauseTotalNs;
  @JsonKey(name: 'Sys')
  late String sys;
  @JsonKey(name: 'TotalAlloc')
  late String totalAlloc;

  MemoryStats(
    this.alloc,
    this.bySize,
    this.numGC,
    this.pauseEnd,
    this.pauseNs,
    this.pauseTotalNs,
    this.sys,
    this.totalAlloc,
  );

  factory MemoryStats.fromJson(Map<String, dynamic> json) => _$MemoryStatsFromJson(json);

  Map<String, dynamic> toJson() => _$MemoryStatsToJson(this);
}
