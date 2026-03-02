import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homefe/assets/i18n/generated/app_localizations.dart';
import 'package:homefe/functions.dart';
import 'package:homefe/podo/rss/news_item.dart';
import 'package:homefe/podo/rss/rss_site.dart';
import 'package:homefe/theme/theme.dart';
import 'package:rss_dart/domain/rss_item.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:collection/collection.dart';

final Map<String, String> _urlMap = {
  "": "assets/thumbnails/random-source.svg",
  "Phoronix": "assets/thumbnails/phoronix.svg",
  "Slashdot": "assets/thumbnails/slashdot.svg",
  "TechCrunch": "assets/thumbnails/techcrunch.svg",
  "Dpreview": "assets/thumbnails/dpreview.svg",
  "Tom's Hardware": "assets/thumbnails/toms-hardware.svg",
  "Ars Technica": "assets/thumbnails/ars-technica.svg",
  "Hacker News": "assets/thumbnails/hacker-news.svg",
  "The Register": "assets/thumbnails/register.svg",
  "The Verge": "assets/thumbnails/verge.svg",
  "Wired": "assets/thumbnails/wired.svg",
};

Widget _buildImagePreview(SvgPicture? image) {
  return ClipRRect(borderRadius: BorderRadius.circular(8), child: image);
}

String _parseBaseUrl(String url) {
  try {
    final uri = Uri.parse(url);
    return '${uri.scheme}://${uri.host}';
  } catch (e) {
    return url;
  }
}

class JsonFeedTile extends StatelessWidget {
  const JsonFeedTile({
    super.key,
    required this.onItemTap,
    this.onItemLongPress,
    required this.item,
  });

  final VoidCallback onItemTap;
  final VoidCallback? onItemLongPress;
  final NewsItem item;

  String get _baseUrl => _parseBaseUrl(item.link);
  String get _description => parseDescription(item, true);

  DateTime get _publishedDate => parsePublishedParsed(item.publishedParsed);
  bool get _isToday => _publishedDate.day == DateTime.now().day;

  String _formatDate() {
    final now = DateTime.now();
    return _isToday
        ? timeago.format(_publishedDate, locale: 'en_short', clock: now)
        : timeago.format(_publishedDate, locale: 'en', clock: now);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onItemTap,
        onLongPress: onItemLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 8),
              if (_description.isNotEmpty) ...[
                Text(
                  _description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
              ],
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            _isToday ? Icons.timer_outlined : Icons.calendar_today,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_formatDate()} • ${item.title}',
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    SvgPicture? image = _getImage();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (image != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ColoredBox(
              color: Theme.of(context).colorScheme.inversePrimary,
              child: _buildImagePreview(image),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Text(
          _baseUrl,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            decoration: TextDecoration.underline,
            color: AppColors.linkBlue,
            decorationColor: AppColors.linkBlue,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  SvgPicture? _getImage() {
    if (item.source == null) {
      return SvgPicture.asset(
        'assets/thumbnails/random-source.svg',
        key: const ValueKey('random-source'),
        width: 80,
        height: 80,
      );
    }

    try {
      String? source = item.source;

      for (final key in _urlMap.keys) {
        if (source == key) {
          String? value = _urlMap.entries.firstWhereOrNull((entry) => entry.key == key)?.value;
          if (value != null) {
            return SvgPicture.asset(
              value,
              key: ValueKey(value),
              width: 80,
              height: 80,
            );
          } else {
            return null;
          }
        }
      }
    } catch (e) {
      return null;
    }

    return null;
  }
}

class RssFeedTile extends StatelessWidget {
  const RssFeedTile({
    super.key,
    required this.openItem,
    required this.index,
    required this.item,
    required this.site,
  });

  final VoidCallback openItem;
  final RssItem item;
  final RssSite site;
  final int index;

  String get _baseUrl => _parseBaseUrl(item.link ?? '');
  String get _description => parseDescription(
    NewsItem(
      item.title ?? '',
      item.description ?? '',
      item.link ?? '',
      item.pubDate.toString(),
    ),
    true,
  );

  DateTime get _publishedDate => parsePublishedParsed(item.pubDate);
  bool get _isToday => _publishedDate.day == DateTime.now().day;

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            _isToday ? Icons.timer_outlined : Icons.calendar_today,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_formatDate()} • ${item.title ?? AppLocalizations.of(context)!.noTitle}',
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate() {
    final now = DateTime.now();
    return _isToday
        ? timeago.format(_publishedDate, locale: 'en_short', clock: now)
        : timeago.format(_publishedDate, locale: 'en', clock: now);
  }

  Widget _buildFooter(BuildContext context) {
    SvgPicture? image = _getImage();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (image != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ColoredBox(
              color: Theme.of(context).colorScheme.inversePrimary,
              child: _buildImagePreview(image),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Text(
          _baseUrl,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            decoration: TextDecoration.underline,
            color: AppColors.linkBlue,
            decorationColor: AppColors.linkBlue,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: openItem,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 8),
              if (_description.isNotEmpty) ...[
                Text(
                  _description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
              ],
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  SvgPicture? _getImage() {
    try {
      String source = site.title;

      for (final key in _urlMap.keys) {
        if (source == key) {
          String? value = _urlMap.entries.firstWhereOrNull((entry) => entry.key == key)?.value;
          if (value != null) {
            return SvgPicture.asset(
              value,
              key: ValueKey(value),
              width: 80,
              height: 80,
            );
          } else {
            return null;
          }
        }
      }
    } catch (e) {
      return null;
    }

    return null;
  }
}
