/**
 * Copyright 2019 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:matokeo_core/matokeo_core.dart';

import '../models/grade_performance_summary.dart';
import '../decoders/results_decoder.dart';
import '../meta_data_extractors/result_meta_data_extractor.dart';
import '../models/std7_result.dart';

/*-------------------States--------------------------*/

class ResultsState {}

class ResultsLoading extends ResultsState {}

class ResultsLoadingCompleted extends ResultsState {}

class CouncilTitle extends ResultsState with EquatableMixin {
  final String councilTitle;

  CouncilTitle(this.councilTitle);

  @override
  List<Object> get props => [councilTitle];
}

class ResultsTitle extends ResultsState with EquatableMixin {
  final String resultsTitle;

  ResultsTitle(this.resultsTitle);

  @override
  List<Object> get props => [resultsTitle];
}

class SchoolName extends ResultsState with EquatableMixin {
  final String schoolName;

  SchoolName(this.schoolName);

  @override
  List<Object> get props => [schoolName];
}

class SchoolNumber extends ResultsState with EquatableMixin {
  final String schoolNumber;

  SchoolNumber(this.schoolNumber);

  @override
  List<Object> get props => [schoolNumber];
}

class ResultYear extends ResultsState with EquatableMixin {
  final int year;

  ResultYear(this.year);

  @override
  List<Object> get props => [year];
}

class ResultSummary extends ResultsState with EquatableMixin {
  final String summary;

  Map<String, String> get summaryMap {
    return convertToMap(summary, first: '\n', second: ':');
  }

  ResultSummary(this.summary);

  @override
  List<Object> get props => [summary];
}

class ResultLoaded extends ResultsState with EquatableMixin {
  final Std7Result result;

  ResultLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class StudentsGradePerformanceSummary extends ResultsState with EquatableMixin {
  final GradePerformanceSummary summary;

  @override
  List<Object> get props => [summary];

  StudentsGradePerformanceSummary(this.summary);
}
/*-------------------Events--------------------------*/

class _ResultsEvent {}

class _GetSummary extends _ResultsEvent {}

class _GetCouncilTitle extends _ResultsEvent {}

class _GetResultsTitle extends _ResultsEvent {}

class _GetSchoolNumber extends _ResultsEvent {}

class _GetSchoolName extends _ResultsEvent {}

class _GetResultYear extends _ResultsEvent {}

class _ResultEvent extends _ResultsEvent with EquatableMixin {
  final Std7Result result;

  _ResultEvent(this.result);

  @override
  List<Object> get props => [result];
}

class _ResultLoadingEvent extends _ResultsEvent {}

class _GetGradePerformanceSummary extends _ResultsEvent {}

class _LoadingCompletedEvent extends _ResultsEvent {}

/*-------------------Bloc--------------------------*/

class ResultsBloc extends DecoderBloc<_ResultsEvent, ResultsState> {
  ResultMetaDataExtractor _extractor;
  final ResultsDecoder _decoder = ResultsDecoder();

  @override
  void dispatchEvents(String input, {String baseUrl}) {
    dispatchEvent(_ResultLoadingEvent());

    _extractor = ResultMetaDataExtractor(input);

    decode(
        input: input,
        decoder: _decoder,
        listener: (result) {
          dispatchEvent(_ResultEvent(result));
        },
        onDone: () {
          dispatchEvent(_GetSummary());

          dispatchEvent(_GetCouncilTitle());

          dispatchEvent(_GetResultsTitle());

          dispatchEvent(_GetSchoolNumber());

          dispatchEvent(_GetSchoolName());

          dispatchEvent(_GetResultYear());

          dispatchEvent(_GetGradePerformanceSummary());

          //complete event
          dispatchEvent(_LoadingCompletedEvent());
        });
  }

  @override
  Stream<ResultsState> mapEventToState(_ResultsEvent event) async* {
    try {
      if (event is _ResultLoadingEvent) {
        yield ResultsLoading();
      } else if (event is _GetSummary) {
        yield ResultSummary(await _extractor.getResultsSummary());
      } else if (event is _GetCouncilTitle) {
        yield CouncilTitle(await _extractor.getCouncilTitle());
      } else if (event is _GetResultsTitle) {
        yield ResultsTitle(await _extractor.getResultsTitle());
      } else if (event is _GetSchoolNumber) {
        yield SchoolNumber(await _extractor.getSchoolNumber());
      } else if (event is _GetSchoolName) {
        yield SchoolName(await _extractor.getSchoolName());
      } else if (event is _GetResultYear) {
        yield ResultYear(await _extractor.getResultYear());
      } else if (event is _ResultEvent) {
        yield ResultLoaded(event.result);
      } else if (event is _GetGradePerformanceSummary) {
        final summary = await _extractor.getGradePerformanceSummary();
        yield StudentsGradePerformanceSummary(summary);
      } else if (event is _LoadingCompletedEvent) {
        yield ResultsLoadingCompleted();
        complete();
      } else {
        throw MatokeoBlocException(
            'ResultsBloc: mapEventToState, unknown event');
      }
    } catch (e) {
      throw MatokeoBlocException(e.toString());
    }
  }
}
