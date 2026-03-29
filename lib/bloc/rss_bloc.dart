import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homefe/api/api_repository.dart';
import 'package:homefe/logger/logger.dart';
import 'package:homefe/podo/answer/answer_body.dart';
import 'package:homefe/podo/backend/archive.dart';
import 'package:homefe/podo/backend/config.dart';
import 'package:homefe/podo/question/question_body.dart';
import 'package:homefe/podo/rss/news_item.dart';
import 'package:homefe/podo/rss/news_items.dart';
import 'package:homefe/podo/rss/rss_sites.dart';
import 'package:rss_dart/domain/rss_feed.dart';

abstract class RssState {}

class FeedEvent extends RssState {}

class Initial extends FeedEvent {}

class Loading extends FeedEvent {}

class SlowLoading extends Loading {}

class Failure extends FeedEvent {
  final String error;

  Failure(this.error);
}

class RssSitesEvent extends FeedEvent {}

class RssFeedEvent extends FeedEvent {
  final Uri url;

  RssFeedEvent(this.url);
}

class QuestionEvent extends FeedEvent {
  final String question;

  QuestionEvent(this.question);
}

class ConfigEvent extends FeedEvent {}

class RefreshArchive extends FeedEvent {}

class ArchiveLoadMore extends FeedEvent {
  final List<NewsItem> items;

  ArchiveLoadMore(this.items);
}

class RssSitesSuccess extends FeedEvent {
  final RssSites rssSites;

  RssSitesSuccess(this.rssSites);
}

class RssFeedSuccess extends FeedEvent {
  final RssFeed rssFeed;

  RssFeedSuccess(this.rssFeed);
}

class ArchiveLoad extends FeedEvent {
  final List<NewsItem> items;

  ArchiveLoad(this.items);
}

class SearchLoad extends FeedEvent {
  final List<NewsItem> items;

  SearchLoad(this.items);
}

class ArchiveRefreshDone extends FeedEvent {
  final ArchiveStats stats;

  ArchiveRefreshDone(this.stats);
}

class AnswerSuccess extends FeedEvent {
  final String answer;

  AnswerSuccess(this.answer);
}

class ConfigSuccess extends FeedEvent {
  final Config config;

  ConfigSuccess(this.config);
}

class ArticlesEvent extends FeedEvent {
  final String? language;

  ArticlesEvent({this.language});
}

class LoadMoreArchive extends ArticlesEvent {
  LoadMoreArchive({super.language});
}

class SearchArchive extends ArticlesEvent {
  final String query;

  SearchArchive({required this.query, super.language});
}

class ArticleEvent extends ArticlesEvent {
  final int id;

  ArticleEvent({required this.id, super.language});
}

class ResetArchive extends ArticlesEvent {}

class RssSitesBloc extends Bloc<FeedEvent, RssState> {
  ApiRepository repo;

  RssSitesBloc({required this.repo}) : super(Initial()) {
    on<RssSitesEvent>((event, emit) async {
      emit(Loading());

      RssSites? rssSite = await repo.sites();
      if (rssSite == null) {
        emit(Failure('Cannot get RSS sites'));
      } else {
        emit(RssSitesSuccess(rssSite));
      }
    });
  }
}

class RssArchiveBloc extends Bloc<FeedEvent, RssState> {
  ApiRepository repo;
  int limit = 10;
  int offset = 0;
  bool hasMore = true;
  List<NewsItem> items = [];

  RssArchiveBloc({required this.repo}) : super(Initial()) {
    on<ResetArchive>((event, emit) {
      limit = 10;
      offset = 0;
      hasMore = true;
      items = [];
      emit(Initial());
    });

    on<ArticlesEvent>((event, emit) async {
      if (event is LoadMoreArchive) {
        if (!hasMore) return;

        if (items.isEmpty) {
          emit(Loading());
        } else {
          emit(ArchiveLoadMore(items));
        }

        try {
          NewsItems? newsItems = await repo.articles(
            offset: offset,
            limit: limit,
            language: event.language,
          );

          // int totalItems = newsItems?.totalItems ?? 0;
          limit = newsItems?.limit ?? 0;
          offset = newsItems?.offset ?? 0;

          if (newsItems == null || newsItems.items.isEmpty) {
            hasMore = false;
            emit(ArchiveLoad(items));
            return;
          }

          items.addAll(newsItems.items);
          offset += limit;

          // TODO: disabled in backend for now. there are 10k+ items
          // hasMore = newsItems.items.length == limit && offset < totalItems;
          hasMore = true;

          emit(ArchiveLoad(List.from(items)));
        } catch (e) {
          emit(Failure('Failed to load more items'));
        }
      }
    });

    on<SearchArchive>((event, emit) async {
      try {
        NewsItems? newsItems = await repo.search(query: event.query, language: event.language);

        if (newsItems == null) {
          emit(SearchLoad([]));

          return;
        }

        emit(SearchLoad(newsItems.items));
      } catch (e) {
        emit(Failure('Failed to search archive'));
      }
    });

    on<RefreshArchive>((event, emit) async {
      emit(SlowLoading());
      final (returnCode, data) = await repo.refresh();
      if (returnCode == 200) {
        emit(ArchiveRefreshDone(ArchiveStats.fromJson(data)));
      } else {
        emit(Failure('Error: $data'));
      }
    });

    on<QuestionEvent>((event, emit) async {
      emit(Loading());

      AnswerBody? answer = await repo.answerToQuestion(
        QuestionBody(event.question),
      );
      if (answer == null || answer.answer.isEmpty) {
        emit(Failure('Cannot get answer'));
      } else {
        emit(AnswerSuccess(answer.answer));
      }
    });

    on<ConfigEvent>((event, emit) async {
      emit(Loading());

      Config? config = await repo.getConfig();
      if (config == null) {
        emit(Failure('Cannot get config'));
      } else {
        emit(ConfigSuccess(config));
      }
    });
  }
}

class RssFeedBloc extends Bloc<FeedEvent, RssState> {
  RssFeedBloc() : super(Initial()) {
    on<RssFeedEvent>((event, emit) async {
      emit(Loading());

      try {
        logger.i('onRequest | ${event.url}');
        final dio = Dio();
        final response = await dio.get(event.url.toString());
        logger.i('onResponse | ${event.url} | ${response.statusCode}');

        if (response.statusCode == 200 && response.data != null) {
          try {
            final rssFeed = RssFeed.parse(response.data);
            emit(RssFeedSuccess(rssFeed));
          } catch (e) {
            logger.e('onResponse | ${event.url} | $e');
            emit(Failure(e.toString()));
          }
        } else {
          logger.e('onResponse | ${event.url} | ${response.statusCode}');
          emit(Failure('Failed to load RSS feed: ${response.statusCode}'));
        }
      } catch (error) {
        logger.e('onError | ${event.url} | $error');
        emit(Failure('Error fetching RSS feed: $error'));
      }
    });
  }
}
