import 'package:json_annotation/json_annotation.dart';

part 'archive.g.dart';

@JsonSerializable()
class ArchiveStats {
  @JsonKey(name: 'status')
  late String status;
  @JsonKey(name: 'count')
  late int count;
  @JsonKey(name: 'oldest')
  late String oldest;

  ArchiveStats(
    this.status,
    this.count,
    this.oldest,
  );

  factory ArchiveStats.fromJson(Map<String, dynamic> json) => _$ArchiveStatsFromJson(json);

  Map<String, dynamic> toJson() => _$ArchiveStatsToJson(this);
}
