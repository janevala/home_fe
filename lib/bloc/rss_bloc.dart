import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homefe/api/api_repository.dart';
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

class RssArchiveLoadingMore extends RssEvent {
  final List<NewsItem> items;

  RssArchiveLoadingMore(this.items);
}

class RssSitesSuccess extends RssEvent {
  final RssSites rssSites;

  RssSitesSuccess(this.rssSites);
}

class RssFeedSuccess extends RssEvent {
  final RssFeed rssFeed;

  RssFeedSuccess(this.rssFeed);
}

class RssArchiveSuccess extends RssEvent {
  final List<NewsItem> rssArchiveFeed;

  RssArchiveSuccess(this.rssArchiveFeed);
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
  ApiRepository apiRepository;

  RssSitesBloc({required this.apiRepository}) : super(Initial()) {
    on<RssSitesEvent>((event, emit) async {
      emit(Loading());

      RssSites? rssSite = await apiRepository.sites();
      if (rssSite == null) {
        emit(Failure('Cannot get RSS sites'));
      } else {
        emit(RssSitesSuccess(rssSite));
      }
    });
  }
}

class RssArchiveBloc extends Bloc<RssEvent, RssState> {
  ApiRepository apiRepository;
  int limit = 10;
  int offset = 0;
  bool hasMore = true;
  List<NewsItem> items = [];

  RssArchiveBloc({required this.apiRepository}) : super(Initial()) {
    on<RssArchiveEvent>((event, emit) async {
      if (event is LoadMoreArchive) {
        if (!hasMore) return;

        if (items.isEmpty) {
          emit(Loading());
        } else {
          emit(RssArchiveLoadingMore(items));
        }

        try {
          NewsItems? newsItems = await apiRepository.archive(
            offset: offset,
            limit: limit,
          );

          int totalItems = newsItems?.totalItems ?? 0;
          limit = newsItems?.limit ?? 0;
          offset = newsItems?.offset ?? 0;

          if (newsItems == null || newsItems.items.isEmpty) {
            hasMore = false;
            emit(RssArchiveSuccess(items));
            return;
          }

          items.addAll(newsItems.items);
          offset += limit;
          hasMore = newsItems.items.length == limit && offset < totalItems;
          emit(RssArchiveSuccess(List.from(items)));
        } catch (e) {
          emit(Failure('Failed to load more items'));
        }
      }
    });
  }
}

class QuestionBloc extends Bloc<RssEvent, RssState> {
  ApiRepository apiRepository;

  QuestionBloc({required this.apiRepository}) : super(Initial()) {
    on<QuestionEvent>((event, emit) async {
      emit(Loading());

      AnswerBody? answer = await apiRepository.answerToQuestion(
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
        final dio = Dio();
        final response = await dio.get(event.url.toString());

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
