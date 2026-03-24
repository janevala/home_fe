// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'by_size.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BySize _$BySizeFromJson(Map<String, dynamic> json) => BySize(
  json['Size'] as String,
  json['Mallocs`'] as String,
  json['Frees'] as String,
);

Map<String, dynamic> _$BySizeToJson(BySize instance) => <String, dynamic>{
  'Size': instance.size,
  'Mallocs`': instance.mallocs,
  'Frees': instance.frees,
};
