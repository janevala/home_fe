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

class RssInitial extends RssState {}

class Loading extends RssState {}

class RssSitesSuccess extends RssState {
  final RssSites rssSites;

  RssSitesSuccess(this.rssSites);
}

class RssFeedSuccess extends RssState {
  final RssFeed rssFeed;

  RssFeedSuccess(this.rssFeed);
}

class RssArchiveSuccess extends RssState {
  final NewsItems rssArchiveFeed;

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

  RssArchiveBloc() : super(RssInitial()) {
    on<RssArchiveEvent>((event, emit) async {
      emit(Loading());

      NewsItems? archiveFeed = await repo.getArchive();
      if (archiveFeed == null) {
        emit(Failure('Cannot get RSS archive feed'));
      } else {
        emit(RssArchiveSuccess(archiveFeed));
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
