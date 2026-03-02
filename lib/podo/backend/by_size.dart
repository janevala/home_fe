import 'package:json_annotation/json_annotation.dart';

part 'by_size.g.dart';

@JsonSerializable()
class BySize {
  @JsonKey(name: 'Size')
  late String size;
  @JsonKey(name: 'Mallocs`')
  late String mallocs;
  @JsonKey(name: 'Frees')
  late String frees;

  BySize(
    this.size,
    this.mallocs,
    this.frees,
  );

  factory BySize.fromJson(Map<String, dynamic> json) => _$BySizeFromJson(json);

  Map<String, dynamic> toJson() => _$BySizeToJson(this);
}
