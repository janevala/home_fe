import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homefe/assets/i18n/generated/app_localizations.dart';
import 'package:homefe/podo/rss/news_item.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

String parseDescription(NewsItem item, bool cutLong, String? warningText) {
  if (item.source == 'Dpreview' || (item.source == 'Hacker News' && item.llm == 'original')) {
    String description = item.title;
    if (warningText != null) {
      description += '\n\n(LLM: ${item.llm ?? 'original'}. $warningText)';
    }
    return description;
  }

  if (item.description.isEmpty) {
    String description = item.title;
    if (warningText != null) {
      description += '\n\n(LLM: ${item.llm ?? 'original'}. $warningText)';
    }

    return description;
  }

  try {
    final document = parse(item.description);
    String description = document.body?.text ?? '';
    description = description.replaceAll(' \n', '');

    if (cutLong && description.length > 500) {
      description = '${description.substring(0, 500)}...';
    }

    if (warningText != null) {
      description += '\n\n(LLM: ${item.llm ?? 'original'}. $warningText)';
    }

    return description;
  } catch (e) {
    return item.description;
  }
}

openItem(BuildContext context, NewsItem item) async {
  String? warningText;
  if (item.llm != null && item.llm != 'original') {
    warningText = AppLocalizations.of(context)!.translationMayContainErrors;
  }
  String description = parseDescription(item, false, warningText);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: SelectableText(
          item.title,
        ),
        content: SelectableText(
          description,
        ),
        actions: [
          InkWell(
            onTap: () {
              SharePlus.instance.share(ShareParams(text: '${item.title}\n\n$description'));
              Navigator.pop(context, true);
            },
            child: Icon(Icons.share, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: '${item.title}\n\n$description'));
              Navigator.pop(context, true);
            },
            child: Icon(Icons.copy, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, true);

              if (await canLaunchUrl(Uri.parse(item.link))) {
                await launchUrl(Uri.parse(item.link));
              }
            },
            child: Text(
              item.llm == 'original' ? AppLocalizations.of(context)!.open : AppLocalizations.of(context)!.openOriginal,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppLocalizations.of(context)!.close,
            ),
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

// void updateOnLocaleChange(BuildContext context, Locale newLocale) {
//   context.read<LocaleCubit>().changeLocaleTo(newLocale);
// }

String getLocalizedDate(BuildContext context, DateTime date) {
  final Locale locale = Localizations.localeOf(context);
  // return timeago.format(date, locale: locale.languageCode, clock: DateTime.now());
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
