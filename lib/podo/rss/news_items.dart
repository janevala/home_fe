// ignore: depend_on_referenced_packages
import 'package:homefe/podo/rss/news_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'news_items.g.dart';

@JsonSerializable()
class NewsItems {
  @JsonKey(name: 'items')
  late List<NewsItem> items;
  @JsonKey(name: 'totalItems')
  late int totalItems;
  @JsonKey(name: 'limit')
  late int limit;
  @JsonKey(name: 'offset')
  late int offset;

  NewsItems(this.items, this.totalItems, this.limit, this.offset);

  factory NewsItems.fromJson(Map<String, dynamic> json) =>
      _$NewsItemsFromJson(json);

  Map<String, dynamic> toJson() => _$NewsItemsToJson(this);
}
