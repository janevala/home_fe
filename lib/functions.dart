import 'package:flutter/material.dart';
import 'package:homefe/assets/i18n/generated/app_localizations.dart';
import 'package:homefe/podo/rss/news_item.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

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
  String description = parseDescription(item, false);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: SelectableText(
          item.title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        content: SelectableText(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
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
              AppLocalizations.of(context)!.open,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppLocalizations.of(context)!.close,
              style: Theme.of(context).textTheme.labelLarge,
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

String? getLocalizedDate(BuildContext context, DateTime? date) {
  if (date == null) return null;

  final String locale = Localizations.localeOf(context).languageCode;
  final DateFormat formatter = DateFormat.yMMMd(locale);
  return formatter.format(date);
}
