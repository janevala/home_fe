import 'package:flutter/material.dart';
import 'package:homefe/podo/rss/news_item.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import 'package:flutter/services.dart';

Future<String?> readBaseUrl() async {
  try {
    final api = await rootBundle.loadString('api/.api');
    return api.trim();
  } catch (e) {
    return null;
  }
}

String parseDescription(NewsItem item, bool cutLong) {
  if (item.source == 'Dpreview') {
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

  String documentString = parseDescription(item, false);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: SizedBox(
          width: width * 0.5,
          child: SelectableText(
            item.title,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        content: SizedBox(
          width: width * 0.5,
          child: SingleChildScrollView(
            child: SelectableText(
              documentString,
              style: const TextStyle(fontSize: 14),
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

  return DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(str, true);
}
