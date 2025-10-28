import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homefe/functions.dart';
import 'package:homefe/podo/rss/news_item.dart';
import 'package:homefe/podo/rss/rss_site.dart';
import 'package:html/parser.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:webfeed/webfeed.dart';
import 'package:collection/collection.dart';

class JsonFeedTile extends StatelessWidget {
  JsonFeedTile({
    super.key,
    required this.onItemTap,
    this.onItemLongPress,
    required this.item,
  });

  final VoidCallback onItemTap;
  final VoidCallback? onItemLongPress;
  final NewsItem item;

  String get _baseUrl => _parseBaseUrl(item.link);
  String get _description {
    if (item.source == 'Dpreview') {
      return item.title;
    }

    return _parseDescription(item.description);
  }

  DateTime get _publishedDate => parsePublishedParsed(item.publishedParsed);
  bool get _isToday => _publishedDate.day == DateTime.now().day;

  static String _parseBaseUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return '${uri.scheme}://${uri.host}';
    } catch (e) {
      return url;
    }
  }

  static String _parseDescription(String? html) {
    if (html == null || html.isEmpty) return '';
    try {
      final document = parse(html);
      final text = document.body?.text ?? '';
      return text.length > 500 ? '${text.substring(0, 500)}...' : text;
    } catch (e) {
      return html;
    }
  }

  String _formatDate() {
    final now = DateTime.now();
    return _isToday
        ? timeago.format(_publishedDate, locale: 'en_short', clock: now)
        : timeago.format(_publishedDate, locale: 'en', clock: now);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: onItemTap,
        onLongPress: null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(textTheme),
              const SizedBox(height: 8),
              if (_description.isNotEmpty) ...[
                Text(_description, style: textTheme.bodyMedium),
                const SizedBox(height: 12),
              ],
              _buildFooter(theme, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          _isToday ? Icons.timer_outlined : Icons.calendar_today,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_formatDate()} • ${item.title}',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme, BuildContext context) {
    Image? image = _getImage();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (image != null) ...[
          _buildImagePreview(image),
          const SizedBox(width: 12),
        ],
        GestureDetector(
          onTap: () => _copyToClipboard(_baseUrl, context),
          child: Text(
            _baseUrl,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(Image? image) {
    return ClipRRect(borderRadius: BorderRadius.circular(8), child: image);
  }

  /// TEMPORARY JUST TO SEE UI, WILL BE DONE IN BACKEND
  final Map<String, String> _urlMap = {
    "": "assets/thumbnails/Copilot_20251021_202857.png",
    "Phoronix": "assets/thumbnails/Copilot_20251021_194755.png",
    "Slashdot": "assets/thumbnails/Copilot_20251021_194619.png",
    "Tom's Hardware": "assets/thumbnails/Copilot_20251021_194521.png",
    "TechCrunch": "assets/thumbnails/Copilot_20251021_194404.png",
    "Dpreview": "assets/thumbnails/Copilot_20251024_195657.png",
  };

  Image? _getImage() {
    if (item.source == null) {
      return const Image(
        image: AssetImage('assets/thumbnails/Copilot_20251021_202857.png'),
        width: 80,
        height: 80,
      );
    }

    try {
      String? source = item.source;

      for (final key in _urlMap.keys) {
        if (source == key) {
          String? value = _urlMap.entries
              .firstWhereOrNull((entry) => entry.key == key)
              ?.value;
          if (value != null) {
            return Image(image: AssetImage(value), width: 80, height: 80);
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

  void _copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Link copied to clipboard')));
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

  String get _description {
    if (item.description == null) return '';
    try {
      final document = parse(item.description!);
      final text = document.body?.text ?? '';
      return text.length > 500 ? '${text.substring(0, 500)}...' : text;
    } catch (e) {
      return item.description!;
    }
  }

  String _formatDate() {
    if (item.pubDate == null) return '';
    return timeago.format(item.pubDate!, locale: 'en');
  }

  Widget _buildHeader(TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.article_outlined, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            item.title ?? 'No title',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            site.title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            if (item.pubDate != null) ...[
              const Icon(Icons.schedule_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                _formatDate(),
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: openItem,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(textTheme),
              if (_description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(_description, style: textTheme.bodyMedium),
              ],
              const SizedBox(height: 12),
              _buildFooter(theme, context),
            ],
          ),
        ),
      ),
    );
  }
}
