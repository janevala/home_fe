import 'package:flutter/material.dart';
import 'package:homefe/podo/rss/rss_json_feed.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';

openItem(BuildContext context, RssJsonFeed item) {
  String documentString = parse(item.content).documentElement!.text;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: SingleChildScrollView(
            child: Text('${item.title}\n\n$documentString')),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context, true);

              if (await canLaunchUrl(Uri.parse(item.link))) {
                await launchUrl(Uri.parse(item.link));
              }
            },
            child: const Text('Open', style: TextStyle(fontSize: 18)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Close', style: TextStyle(fontSize: 18)),
          ),
        ],
      );
    },
  );
}
