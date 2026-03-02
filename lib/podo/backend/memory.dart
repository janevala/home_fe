// import 'package:homefe/podo/backend/by_size.dart';
import 'package:json_annotation/json_annotation.dart';

part 'memory.g.dart';

@JsonSerializable()
class MemoryStats {
  @JsonKey(name: 'Alloc')
  late int alloc;
  // @JsonKey(name: 'BySize')
  // late List<BySize> bySize;
  @JsonKey(name: 'NumGC')
  late int numGC;
  @JsonKey(name: 'PauseEnd')
  late List<int> pauseEnd;
  @JsonKey(name: 'PauseNs')
  late List<int> pauseNs;
  @JsonKey(name: 'PauseTotalNs')
  late int pauseTotalNs;
  @JsonKey(name: 'Sys')
  late int sys;
  @JsonKey(name: 'TotalAlloc')
  late int totalAlloc;

  MemoryStats(
    this.alloc,
    // this.bySize,
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
