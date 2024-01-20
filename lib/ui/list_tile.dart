import 'package:flutter/material.dart';
import 'package:homefe/podo/rss/rss_json_feed.dart';
import 'package:homefe/podo/rss/rss_site.dart';
import 'package:intl/intl.dart';
import 'package:webfeed/webfeed.dart';

class JsonFeedTile extends StatelessWidget {
  const JsonFeedTile(
      {super.key,
      required this.openItem,
      required this.index,
      required this.item});

  final VoidCallback openItem;
  final RssJsonFeed item;
  final int index;

  DateTime itemPubDate(String dateString) {
    return DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(dateString);
  }

  @override
  Widget build(BuildContext context) {
    DateTime itemPubDate = this.itemPubDate(item.publishedParsed);
    String baseUrl = item.link.substring(0, item.link.indexOf('/', 8));
    String printIndex = (index + 1).toString();
    bool hasContent = item.content != null;

    return ListTile(
      onTap: () async {
        hasContent ? openItem : null;
      },
      title: Text('$printIndex. ${item.title}',
          style: const TextStyle(fontSize: 18)),
      subtitle: Column(
        children: [
          hasContent
              ? Text('${item.content!.substring(0, 100)}...',
                  style: const TextStyle(fontSize: 16))
              : Text(item.description, style: const TextStyle(fontSize: 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                  '- Published: ${itemPubDate.day}/${itemPubDate.month}/${itemPubDate.year} ${itemPubDate.hour}:${itemPubDate.minute} Source: $baseUrl',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
      leading: Icon(
          item.content == null ? Icons.article_outlined : Icons.article_rounded,
          size: 45),
      contentPadding:
          const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
    );
  }
}

class RssFeedTile extends StatelessWidget {
  const RssFeedTile(
      {super.key,
      required this.openItem,
      required this.index,
      required this.item,
      required this.site});

  final VoidCallback openItem;
  final RssItem item;
  final RssSite site;
  final int index;

  @override
  Widget build(BuildContext context) {
    bool hasContent = item.content != null;
    String printIndex = (index + 1).toString();

    return ListTile(
      onTap: () async {
        hasContent ? openItem() : null;
      },
      title: Text('$printIndex. ${item.title}',
          style: const TextStyle(fontSize: 18)),
      subtitle: Column(
        children: [
          hasContent
              ? Container()
              : Text(item.description!, style: const TextStyle(fontSize: 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                  '- Published: ${item.pubDate!.day}/${item.pubDate!.month}/${item.pubDate!.year} ${item.pubDate!.hour}:${item.pubDate!.minute} Source: ${site.title}',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
      leading: Icon(
          item.content == null ? Icons.article_outlined : Icons.article_rounded,
          size: 45),
      contentPadding:
          const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
    );
  }
}
