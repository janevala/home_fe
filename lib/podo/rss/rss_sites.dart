import 'package:homefe/podo/rss/rss_site.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rss_sites.g.dart';

@JsonSerializable(ignoreUnannotated: true)
class RssSites {
  @JsonKey(name: 'time')
  late int time;
  @JsonKey(name: 'title')
  late String title;
  @JsonKey(name: 'sites')
  late List<RssSite> sites;
  String error = '';

  RssSites(this.time, this.title, this.sites);

  RssSites.withError(this.error);

  factory RssSites.fromJson(Map<String, dynamic> json) => _$RssSitesFromJson(json);

  Map<String, dynamic> toJson() => _$RssSitesToJson(this);
}
