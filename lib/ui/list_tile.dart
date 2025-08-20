import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:homefe/functions.dart';
import 'package:homefe/podo/rss/rss_json_feed.dart';
import 'package:homefe/podo/rss/rss_site.dart';
import 'package:html/parser.dart';
import 'package:webfeed/webfeed.dart';
import 'package:timeago/timeago.dart' as timeago;

class JsonFeedTile extends StatelessWidget {
  const JsonFeedTile(
      {super.key,
      required this.openItem,
      required this.explainItem,
      required this.index,
      required this.item});

  final VoidCallback openItem;
  final VoidCallback explainItem;
  final RssJsonFeed item;
  final int index;

  @override
  Widget build(BuildContext context) {
    String baseUrl = item.link.substring(0, item.link.indexOf('/', 8));
    String parsedDescription = parse(item.description).body!.text;
    if (parsedDescription.length > 500) {
      parsedDescription = '${parsedDescription.substring(0, 500)}...';
    }

    DateTime itemPubDate = parsePublishedParsed(item.publishedParsed);
    String dateString = itemPubDate.day == DateTime.now().day
        ? timeago.format(itemPubDate, locale: 'en_short')
        : timeago.format(itemPubDate, locale: 'en');
    String imageUrl = '';
    if (item.linkImage != null && !item.linkImage!.contains("www.google.com")) {
      Uri uri = Uri();
      uri = Uri.parse(item.linkImage!);
      imageUrl = '${uri.scheme}://${uri.authority}${uri.path}';
    }

    return ListTile(
      onLongPress: () async {
        // explainItem.call();
      },
      onTap: () async {
        openItem.call();
      },
      title: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: itemPubDate.day == DateTime.now().day
                  ? const Icon(Icons.timer_outlined)
                  : const Icon(Icons.calendar_today),
            ),
            TextSpan(
                text: ' $dateString | ${item.title}',
                style: const TextStyle(color: Colors.black, fontSize: 22)),
          ],
        ),
      ),
      titleTextStyle: const TextStyle(fontSize: 22, color: Colors.black),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(parsedDescription),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              imageUrl.isEmpty
                  ? const SizedBox(height: 50, width: 50)
                  : CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
              Text.rich(
                TextSpan(
                  text: '- Source: ',
                  style: const TextStyle(fontSize: 16),
                  children: <TextSpan>[
                    TextSpan(
                        text: baseUrl,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        )),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
      subtitleTextStyle: const TextStyle(fontSize: 18, color: Colors.black),
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
    String parsedDescription = parse(item.description!).body!.text;
    if (parsedDescription.length > 500) {
      parsedDescription = '${parsedDescription.substring(0, 500)}...';
    }

    return ListTile(
      onTap: () async {
        openItem.call();
      },
      title: Text('#$printIndex. | ${item.title}',
          style: const TextStyle(color: Colors.black, fontSize: 22)),
      titleTextStyle: const TextStyle(fontSize: 22, color: Colors.black),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          hasContent
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(parsedDescription),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                  item.pubDate != null
                      ? '- Published ${timeago.format(item.pubDate!, locale: 'en')} Source ${site.title}'
                      : '- Source ${site.title}',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
      subtitleTextStyle: const TextStyle(fontSize: 18, color: Colors.black),
      contentPadding:
          const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
    );
  }
}
