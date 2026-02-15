// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'http.g.dart';

@JsonSerializable()
class HttpStats {
  @JsonKey(name: 'AvgResponseTime')
  late String avgResponseTime;
  @JsonKey(name: 'RequestsByMethod')
  late Map<String, int> requestsByMethod;
  @JsonKey(name: 'ResponseCodeCount')
  late Map<String, int> responseCodeCount;
  @JsonKey(name: 'TotalRequests')
  late int totalRequests;
  @JsonKey(name: 'TotalResponseTime')
  late String totalResponseTime;

  HttpStats(
    this.avgResponseTime,
    this.requestsByMethod,
    this.responseCodeCount,
    this.totalRequests,
    this.totalResponseTime,
  );

  factory HttpStats.fromJson(Map<String, dynamic> json) =>
      _$HttpStatsFromJson(json);

  Map<String, dynamic> toJson() => _$HttpStatsToJson(this);
}
