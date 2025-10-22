// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsItems _$NewsItemsFromJson(Map<String, dynamic> json) => NewsItems(
  (json['items'] as List<dynamic>)
      .map((e) => NewsItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  (json['totalItems'] as num).toInt(),
  (json['limit'] as num).toInt(),
  (json['offset'] as num).toInt(),
);

Map<String, dynamic> _$NewsItemsToJson(NewsItems instance) => <String, dynamic>{
  'items': instance.items,
  'totalItems': instance.totalItems,
  'limit': instance.limit,
  'offset': instance.offset,
};
