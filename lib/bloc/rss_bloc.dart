import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homefe/api/api_repository.dart';
import 'package:homefe/podo/answer/answer_body.dart';
import 'package:homefe/podo/question/question_body.dart';
import 'package:homefe/podo/rss/news_item.dart';
import 'package:homefe/podo/rss/news_items.dart';
import 'package:homefe/podo/rss/rss_sites.dart';
import 'package:webfeed/webfeed.dart';

abstract class RssState {}

class RssSitesEvent extends RssState {}

class RssFeedEvent extends RssState {
  final Uri url;

  RssFeedEvent(this.url);
}

class RssArchiveEvent extends RssState {}

class LoadMoreArchive extends RssArchiveEvent {}

class RssInitial extends RssState {}

class Loading extends RssState {}

class RssArchiveLoadingMore extends RssState {
  final List<NewsItem> items;

  RssArchiveLoadingMore(this.items);
}

class RssSitesSuccess extends RssState {
  final RssSites rssSites;

  RssSitesSuccess(this.rssSites);
}

class RssFeedSuccess extends RssState {
  final RssFeed rssFeed;

  RssFeedSuccess(this.rssFeed);
}

class RssArchiveSuccess extends RssState {
  final List<NewsItem> rssArchiveFeed;

  RssArchiveSuccess(this.rssArchiveFeed);
}

class QuestionEvent extends RssState {
  final String question;

  QuestionEvent(this.question);
}

class AnswerSuccess extends RssState {
  final String answer;

  AnswerSuccess(this.answer);
}

class Failure extends RssState {
  final String error;

  Failure(this.error);
}

class RssSitesBloc extends Bloc<RssSitesEvent, RssState> {
  final ApiRepository repo = ApiRepository();

  RssSitesBloc() : super(RssInitial()) {
    on<RssSitesEvent>((event, emit) async {
      emit(Loading());

      RssSites rssSite = await repo.getSites();
      if (rssSite.error.isNotEmpty) {
        emit(Failure(rssSite.error));
      } else {
        emit(RssSitesSuccess(rssSite));
      }
    });
  }
}

class RssArchiveBloc extends Bloc<RssArchiveEvent, RssState> {
  final ApiRepository repo = ApiRepository();
  int limit = 10;
  int offset = 0;
  bool hasMore = true;
  List<NewsItem> items = [];

  RssArchiveBloc() : super(RssInitial()) {
    on<RssArchiveEvent>((event, emit) async {
      if (event is LoadMoreArchive) {
        if (!hasMore) return;

        if (items.isEmpty) {
          emit(Loading());
        } else {
          emit(RssArchiveLoadingMore(items));
        }

        try {
          NewsItems? newsItems =
              await repo.getArchive(offset: offset, limit: limit);

          int totalItems = newsItems?.totalItems ?? 0;
          limit = newsItems?.limit ?? 0;
          offset = newsItems?.offset ?? 0;

          if (newsItems == null || newsItems.items.isEmpty) {
            hasMore = false;
            emit(RssArchiveSuccess(items));
            return;
          }

          items.addAll(newsItems.items);
          // offset += limit; // DEBUG
          hasMore = newsItems.items.length == limit && offset < totalItems;
          emit(RssArchiveSuccess(List.from(items)));
        } catch (e) {
          emit(Failure('Failed to load more items'));
        }
      }
    });
  }
}

class RssFeedBloc extends Bloc<RssFeedEvent, RssState> {
  final ApiRepository repo = ApiRepository();

  RssFeedBloc() : super(RssInitial()) {
    on<RssFeedEvent>((event, emit) async {
      emit(Loading());

      RssFeed? rssFeed = await repo.getRss(event.url);
      if (rssFeed == null) {
        emit(Failure('Cannot get RSS feed'));
      } else {
        emit(RssFeedSuccess(rssFeed));
      }
    });
  }
}

class QuestionBloc extends Bloc<QuestionEvent, RssState> {
  final ApiRepository repo = ApiRepository();

  QuestionBloc() : super(RssInitial()) {
    on<QuestionEvent>((event, emit) async {
      emit(Loading());

      AnswerBody? answer =
          await repo.answerToQuestion(QuestionBody(event.question));
      if (answer == null) {
        emit(Failure('Cannot get answer'));
      } else {
        emit(AnswerSuccess(answer.answer));
      }
    });
  }
}
