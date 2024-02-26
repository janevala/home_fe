import 'package:flutter/material.dart';
import 'package:homefe/functions.dart';
import 'package:homefe/podo/rss/rss_json_feed.dart';
import 'package:homefe/podo/rss/rss_site.dart';
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

  @override
  Widget build(BuildContext context) {
    DateTime itemPubDate = parsePublishedParsed(item.publishedParsed);
    String baseUrl = item.link.substring(0, item.link.indexOf('/', 8));

    return ListTile(
      onTap: () async {
        openItem.call();
      },
      title: Text('${formatPublishedShort(itemPubDate)} - ${item.title}',
          style: const TextStyle(fontSize: 18)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(item.description, style: const TextStyle(fontSize: 18)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('- Source $baseUrl', style: const TextStyle(fontSize: 16)),
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
        openItem.call();
      },
      title: Text('$printIndex. ${item.title}',
          style: const TextStyle(fontSize: 18)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          hasContent
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(item.description!,
                      style: const TextStyle(fontSize: 18)),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                  item.pubDate != null
                      ? '- Published ${formatPublished(item.pubDate!)} Source ${site.title}'
                      : '- Source ${site.title}',
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
