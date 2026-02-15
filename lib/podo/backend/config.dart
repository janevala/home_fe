// ignore: depend_on_referenced_packages
import 'package:homefe/podo/backend/database.dart';
import 'package:homefe/podo/backend/http.dart';
import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable()
class Config {
  @JsonKey(name: 'os')
  late String os;
  @JsonKey(name: 'arch')
  late String arch;
  @JsonKey(name: 'version')
  late String version;
  @JsonKey(name: 'go_version')
  late String goVersion;
  @JsonKey(name: 'num_cpu')
  late int numCpu;
  @JsonKey(name: 'num_goroutine')
  late int numGoroutine;
  @JsonKey(name: 'num_gomaxprocs')
  late int numGomaxprocs;
  @JsonKey(name: 'num_cgo_call')
  late int numCgoCall;
  @JsonKey(name: 'db_stats')
  late DatabaseStats dbStats;
  @JsonKey(name: 'http_stats')
  late HttpStats httpStats;

  Config(
    this.os,
    this.arch,
    this.version,
    this.goVersion,
    this.numCpu,
    this.numGoroutine,
    this.numGomaxprocs,
    this.numCgoCall,
    this.dbStats,
    this.httpStats,
  );

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}
