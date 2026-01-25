import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homefe/api/api_repository.dart';
import 'package:homefe/logger/logger.dart';
import 'package:homefe/podo/answer/answer_body.dart';
import 'package:homefe/podo/question/question_body.dart';
import 'package:homefe/podo/rss/news_item.dart';
import 'package:homefe/podo/rss/news_items.dart';
import 'package:homefe/podo/rss/rss_sites.dart';
import 'package:webfeed/webfeed.dart';

abstract class RssState {}

class RssEvent extends RssState {}

class Initial extends RssEvent {}

class Loading extends RssEvent {}

class Failure extends RssEvent {
  final String error;

  Failure(this.error);
}

class RssSitesEvent extends RssEvent {}

class RssFeedEvent extends RssEvent {
  final Uri url;

  RssFeedEvent(this.url);
}

class RssArchiveEvent extends RssEvent {}

class LoadMoreArchive extends RssArchiveEvent {}

class SearchArchive extends RssArchiveEvent {
  final String query;

  SearchArchive({required this.query});
}

class RefreshArchive extends RssArchiveEvent {}

// TODO: this is probably redundant
class ResetArchive extends RssArchiveEvent {}

class ArchiveLoadMore extends RssEvent {
  final List<NewsItem> items;

  ArchiveLoadMore(this.items);
}

class RssSitesSuccess extends RssEvent {
  final RssSites rssSites;

  RssSitesSuccess(this.rssSites);
}

class RssFeedSuccess extends RssEvent {
  final RssFeed rssFeed;

  RssFeedSuccess(this.rssFeed);
}

class ArchiveLoad extends RssEvent {
  final List<NewsItem> items;

  ArchiveLoad(this.items);
}

class SearchLoad extends RssEvent {
  final List<NewsItem> items;

  SearchLoad(this.items);
}

class ArchiveRefreshDone extends RssEvent {
  final String message;

  ArchiveRefreshDone(this.message);
}

class QuestionEvent extends RssEvent {
  final String question;

  QuestionEvent(this.question);
}

class AnswerSuccess extends RssEvent {
  final String answer;

  AnswerSuccess(this.answer);
}

class RssSitesBloc extends Bloc<RssEvent, RssState> {
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

class RssArchiveBloc extends Bloc<RssEvent, RssState> {
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

    on<RssArchiveEvent>((event, emit) async {
      if (event is LoadMoreArchive) {
        if (!hasMore) return;

        if (items.isEmpty) {
          emit(Loading());
        } else {
          emit(ArchiveLoadMore(items));
        }

        try {
          NewsItems? newsItems = await repo.archive(
            offset: offset,
            limit: limit,
          );

          int totalItems = newsItems?.totalItems ?? 0;
          limit = newsItems?.limit ?? 0;
          offset = newsItems?.offset ?? 0;

          if (newsItems == null || newsItems.items.isEmpty) {
            hasMore = false;
            emit(ArchiveLoad(items));
            return;
          }

          items.addAll(newsItems.items);
          offset += limit;
          hasMore = newsItems.items.length == limit && offset < totalItems;
          emit(ArchiveLoad(List.from(items)));
        } catch (e) {
          emit(Failure('Failed to load more items'));
        }
      }
    });

    on<SearchArchive>((event, emit) async {
      try {
        NewsItems? newsItems = await repo.search(query: event.query);

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
      emit(Loading());
      final (returnCode, data) = await repo.refresh();
      if (returnCode == 200) {
        emit(ArchiveRefreshDone(data));
      } else {
        emit(Failure('Error: $data'));
      }
    });
  }
}

class QuestionBloc extends Bloc<RssEvent, RssState> {
  ApiRepository repo;

  QuestionBloc({required this.repo}) : super(Initial()) {
    on<QuestionEvent>((event, emit) async {
      emit(Loading());

      AnswerBody? answer = await repo.answerToQuestion(
        QuestionBody(event.question),
      );
      if (answer == null) {
        emit(Failure('Cannot get answer'));
      } else {
        emit(AnswerSuccess(answer.answer));
      }
    });
  }
}

/// DIRECT FEED RETRIEVAL
class RssFeedBloc extends Bloc<RssEvent, RssState> {
  RssFeedBloc() : super(Initial()) {
    on<RssFeedEvent>((event, emit) async {
      emit(Loading());

      try {
        logger.i('onRequest | ${event.url}');
        final dio = Dio();
        final response = await dio.get(event.url.toString());
        logger.i('onResponse | ${event.url} | ${response.statusCode}');

        if (response.statusCode == 200 && response.data != null) {
          final rssFeed = RssFeed.parse(response.data);
          emit(RssFeedSuccess(rssFeed));
        } else {
          emit(Failure('Failed to load RSS feed: ${response.statusCode}'));
        }
      } catch (error) {
        emit(Failure('Error fetching RSS feed: $error'));
      }
    });
  }
}
