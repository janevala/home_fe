import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homefe/assets/i18n/generated/app_localizations.dart';
import 'package:homefe/podo/rss/news_item.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

// title lenght in db = 500
// description length in db = 1000
(String, String) parseDescription(NewsItem item, bool cutLong, String? warningText) {
  if (item.source == 'Dpreview' || (item.source == 'Hacker News' && item.llm == 'original')) {
    String description = item.title;
    if (warningText != null) {
      description += '\n\n($warningText)';
    }

    return (description, item.title);
  }

  if (item.description.isEmpty) {
    String description = item.title;
    if (warningText != null) {
      description += '\n\n($warningText)';
    }

    return (description, item.title);
  }

  try {
    final document = parse(item.description);
    String description = document.body?.text ?? '';
    description = description.replaceAll(' \n', '');

    if (cutLong && description.length > 950) {
      description = '${description.substring(0, 950)}...';
    }

    String descriptionForShare = description;

    if (warningText != null) {
      description += '\n\n($warningText)';
    }

    return (description, descriptionForShare);
  } catch (e) {
    return (item.description, item.description);
  }
}

Future<void> openItem(BuildContext context, NewsItem item) async {
  if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
    await openMobileItem(context, item);
  } else {
    await openWebItem(context, item);
  }
}

Future<void> openMobileItem(BuildContext context, NewsItem item) async {
  String? warningText;
  if (item.llm != null && item.llm != 'original') {
    warningText = AppLocalizations.of(context)!.translationMayContainErrors;
  }

  final (description, descriptionForShare) = parseDescription(item, false, warningText);
  final messenger = ScaffoldMessenger.of(context);

  showDialog(
    context: context,
    builder: (context) {
      final controller = ScrollController();

      return AlertDialog(
        title: SelectableText(
          item.title,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Scrollbar(
              controller: controller,
              child: SingleChildScrollView(
                controller: controller,
                child: SelectableText(description),
              ),
            ),
          ),
        ),
        buttonPadding: EdgeInsets.zero,
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context, true);

              if (await canLaunchUrl(Uri.parse(item.link))) {
                await launchUrl(Uri.parse(item.link));
              }
            },
            child: Text(
              AppLocalizations.of(context)!.openOriginal,
            ),
          ),
          Tooltip(
            message: AppLocalizations.of(context)!.shareStory,
            child: IconButton(
              onPressed: () {
                if (item.title == item.description) {
                  SharePlus.instance.share(
                    ShareParams(text: '$descriptionForShare\n\n${item.link}'),
                  );
                } else {
                  SharePlus.instance.share(
                    ShareParams(
                      text: '${item.title}\n\n$descriptionForShare\n\n${item.link}',
                    ),
                  );
                }
              },
              icon: Icon(Icons.share, color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Tooltip(
            message: AppLocalizations.of(context)!.copyToClipboard,
            child: IconButton(
              onPressed: () {
                if (item.title == item.description) {
                  Clipboard.setData(ClipboardData(text: '$description\n\n${item.link}'));
                } else {
                  Clipboard.setData(ClipboardData(text: '${item.title}\n\n$descriptionForShare\n\n${item.link}'));
                }

                messenger.showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.copiedToClipboard),
                    duration: const Duration(seconds: 1),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );

                Navigator.pop(context, true);
              },
              icon: Icon(Icons.copy, color: Theme.of(context).colorScheme.primary),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context, true),
            icon: Icon(Icons.close, color: Theme.of(context).colorScheme.primary),
          ),
        ],
      );
    },
  );
}

Future<void> openWebItem(BuildContext context, NewsItem item) async {
  String? warningText;
  if (item.llm != null && item.llm != 'original') {
    warningText = AppLocalizations.of(context)!.translationMayContainErrors;
  }

  final (description, descriptionForShare) = parseDescription(item, false, warningText);
  final messenger = ScaffoldMessenger.of(context);

  showDialog(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(left: 200, right: 200),
        child: AlertDialog(
          title: SelectableText(
            item.title,
          ),
          content: SelectableText(
            description,
          ),
          buttonPadding: EdgeInsets.zero,
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context, true);

                if (await canLaunchUrl(Uri.parse(item.link))) {
                  await launchUrl(Uri.parse(item.link));
                }
              },
              child: Text(
                AppLocalizations.of(context)!.openOriginal,
              ),
            ),
            Tooltip(
              message: AppLocalizations.of(context)!.shareStory,
              child: IconButton(
                onPressed: () {
                  if (item.title == item.description) {
                    SharePlus.instance.share(
                      ShareParams(text: '$descriptionForShare\n\n${item.link}'),
                    );
                  } else {
                    SharePlus.instance.share(
                      ShareParams(
                        text: '${item.title}\n\n$descriptionForShare\n\n${item.link}',
                      ),
                    );
                  }
                },
                icon: Icon(Icons.share, color: Theme.of(context).colorScheme.primary),
              ),
            ),
            Tooltip(
              message: AppLocalizations.of(context)!.copyToClipboard,
              child: IconButton(
                onPressed: () {
                  if (item.title == item.description) {
                    Clipboard.setData(ClipboardData(text: '$description\n\n${item.link}'));
                  } else {
                    Clipboard.setData(ClipboardData(text: '${item.title}\n\n$descriptionForShare\n\n${item.link}'));
                  }

                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.copiedToClipboard),
                      duration: const Duration(seconds: 1),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  );

                  Navigator.pop(context, true);
                },
                icon: Icon(Icons.copy, color: Theme.of(context).colorScheme.primary),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context, true),
              icon: Icon(Icons.close, color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
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
  DateFormat format3 = DateFormat('yyyy-MM-dd HH:mm:ss Z');

  try {
    return format1.parse(str, true);
  } catch (e) {
    try {
      return format2.parse(str, true);
    } catch (e2) {
      try {
        return format3.parse(str, true);
      } catch (e3) {
        return DateTime.now();
      }
    }
  }
}

String getLanguageCode(BuildContext context) {
  Locale locale = Localizations.localeOf(context);
  return locale.languageCode;
}

String fetchLanguageSelectorSelected(BuildContext context, Locale locale) {
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizations.of(context)!.localeDeTranslated;
    case 'en':
      return AppLocalizations.of(context)!.localeEnTranslated;
    case 'es':
      return AppLocalizations.of(context)!.localeEsTranslated;
    case 'fi':
      return AppLocalizations.of(context)!.localeFiTranslated;
    case 'pt':
      return AppLocalizations.of(context)!.localePtTranslated;
    default:
      return locale.languageCode;
  }
}

String getLocalizedDate(BuildContext context, DateTime date) {
  final Locale locale = Localizations.localeOf(context);
  // return timeago.format(date, locale: '${locale.languageCode}_short', clock: DateTime.now());
  final DateFormat formatter = DateFormat.yMMMd(locale.languageCode);
  return formatter.format(date);
}

Future<void> sendEmail({required String subject, required String body}) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'janevala@proton.me',
    query: _encodeQueryParameters(<String, String>{
      'subject': subject,
      'body': body,
    }),
  );

  if (await canLaunchUrl(emailLaunchUri)) {
    await launchUrl(emailLaunchUri);
  } else {
    throw 'Could not launch $emailLaunchUri';
  }
}

String? _encodeQueryParameters(Map<String, String> params) {
  return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
}
