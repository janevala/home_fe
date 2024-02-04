import 'dart:io';

import 'package:flutter/material.dart';
import 'package:homefe/podo/rss/rss_json_feed.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

String readApiEndpointIp(String filePath) {
  try {
    File file = File(filePath);
    String contents = file.readAsStringSync().trim();

    return contents;
  } catch (e) {
    return "http://127.0.0.1:8091";
  }
}

openItem(BuildContext context, RssJsonFeed item) async {
  bool hasContent = item.content != null;

  if (hasContent) {
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
  } else {
    if (await canLaunchUrl(Uri.parse(item.link))) {
      await launchUrl(Uri.parse(item.link));
    }
  }
}

DateTime parsePublished(String str) {
  return DateFormat('EEE, dd MMM yyyy HH:mm:ss zzz').parse(str);
}

DateTime parsePublishedParsed(String str) {
  return DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(str);
}

String formatPublished(DateTime dateTime) {
  return DateFormat('dd. MMM yyyy | HH:mm').format(dateTime);
}

String formatPublishedShort(DateTime dateTime) {
  return DateFormat('HH:mm').format(dateTime);
}
