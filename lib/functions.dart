import 'package:flutter/material.dart';
import 'package:homefe/assets/i18n/generated/app_localizations.dart';
import 'package:homefe/podo/rss/news_item.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

String parseDescription(NewsItem item, bool cutLong, bool showLlm, String? warningText) {
  if (item.source == 'Dpreview' || item.source == 'Hacker News') {
    if (showLlm) {
      return '${item.title}\n\n(llm: ${item.llm ?? 'original'}, ${warningText ?? ''})';
    } else {
      return item.title;
    }
  }

  if (item.description.isEmpty) return '';

  try {
    final document = parse(item.description);
    final text = document.body?.text ?? '';
    text.replaceAll(' \n', '');

    if (cutLong) {
      if (showLlm) {
        return "${text.length > 500 ? '${text.substring(0, 500)}...' : text}\n\n(llm: ${item.llm ?? 'original'}, ${warningText ?? ''})";
      } else {
        return text.length > 500 ? '${text.substring(0, 500)}...' : text;
      }
    } else {
      if (showLlm) {
        return "$text\n\n(llm: ${item.llm ?? 'original'}, ${warningText ?? ''})";
      } else {
        return text;
      }
    }
  } catch (e) {
    return item.description;
  }
}

openItem(BuildContext context, NewsItem item) async {
  String? warningText;
  if (item.llm != null && item.llm != 'original') {
    warningText = AppLocalizations.of(context)!.translationMayContainErrors;
  }
  String description = parseDescription(item, false, true, warningText);

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
