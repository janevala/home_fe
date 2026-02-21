import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:homefe/podo/rss/news_item.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:homefe/constants/app_version.dart';

Future<String?> readBaseUrl() async {
  try {
    return appApi.trim();
  } catch (e) {
    return null;
  }
}

String parseDescription(NewsItem item, bool cutLong) {
  if (item.source == 'Dpreview' || item.source == 'Hacker News') {
    return item.title;
  }

  if (item.description.isEmpty) return '';

  try {
    final document = parse(item.description);
    final text = document.body?.text ?? '';
    text.replaceAll(' \n', '');

    if (cutLong) {
      return text.length > 500 ? '${text.substring(0, 500)}...' : text;
    } else {
      return text;
    }
  } catch (e) {
    return item.description;
  }
}

openItem(BuildContext context, NewsItem item) async {
  double width = MediaQuery.of(context).size.width;
  String description = parseDescription(item, false);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: SizedBox(
          width: width * 0.8,
          child: SelectableText(
            item.title,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        content: SizedBox(
          width: width * 0.8,
          child: SingleChildScrollView(
            child: SelectableText(
              description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context, true);

              if (await canLaunchUrl(Uri.parse(item.link))) {
                await launchUrl(Uri.parse(item.link));
              }
            },
            child: const Text('Open', style: TextStyle(fontSize: 16)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Close', style: TextStyle(fontSize: 16)),
          ),
        ],
      );
    },
  );
}

DateTime parsePublishedParsed(String? str) {
  if (str == null) {
    return DateTime.now();
  }

  DateFormat format1 = DateFormat('EEE, dd MMM yyyy HH:mm:ss Z');
  DateFormat format2 = DateFormat('yyyy-MM-ddTHH:mm:ssZ');

  try {
    return format1.parse(str, true);
  } catch (e) {
    try {
      return format2.parse(str, true);
    } catch (e2) {
      return DateTime.now();
    }
  }
}

bool isMobileBrowser() {
  if (kIsWeb) {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }
  return false;
}
