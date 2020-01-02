/**
 * Copyright 2019 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:matokeo_core/matokeo_core.dart';

import '../decoders/results_link_decoder.dart';
import '../meta_data_extractors/psle_meta_data_extractor.dart';
import '../models/result_link.dart';

/*-------------------States--------------------------*/

class PsleState {}

class PsleLoading extends PsleState {}

class PsleLoadingCompleted extends PsleState {}

class PsleCouncilTitle extends PsleState with EquatableMixin {
  String councilTitle;

  PsleCouncilTitle(this.councilTitle);

  @override
  List<Object> get props => [councilTitle];
}

class PsleResultYear extends PsleState with EquatableMixin {
  int year;

  PsleResultYear(this.year);

  @override
  List<Object> get props => [year];
}

class PsleTitle extends PsleState with EquatableMixin {
  String psleTitle;

  PsleTitle(this.psleTitle);

  @override
  List<Object> get props => [psleTitle];
}

class PsleLink extends PsleState with EquatableMixin {
  ResultLink link;

  PsleLink(this.link);

  @override
  List<Object> get props => [link];
}

/*-------------------Events--------------------------*/

class _PsleEvent {}

class _GetPsleCouncilTitle extends _PsleEvent {}

class _GetPsleTitle extends _PsleEvent {}

class _GetPsleResultYear extends _PsleEvent {}

class _PsleLinkEvent extends _PsleEvent with EquatableMixin {
  ResultLink link;

  _PsleLinkEvent(this.link);

  @override
  List<Object> get props => [link];
}

class _PsleLoadingEvent extends _PsleEvent {}

class _LoadingCompletedEvent extends _PsleEvent {}

/*-------------------Bloc--------------------------*/

class PsleBloc extends DecoderBloc<_PsleEvent, PsleState> {
  PSLEMetaDataExtractor _extractor;

  @override
  void dispatchEvents(String input, {String baseUrl}) {
    dispatchEvent(_PsleLoadingEvent());

    _extractor = PSLEMetaDataExtractor(input);

    decode(
        input: input,
        decoder: ResultsLinkDecoder(baseUrl),
        listener: (link) {
          dispatchEvent(_PsleLinkEvent(link));
        },
        onDone: () {
          dispatchEvent(_GetPsleCouncilTitle());

          dispatchEvent(_GetPsleTitle());

          dispatchEvent(_GetPsleResultYear());

          //complete event
          dispatchEvent(_LoadingCompletedEvent());
        });
  }

  @override
  Stream<PsleState> mapEventToState(_PsleEvent event) async* {
    try {
      if (event is _PsleLoadingEvent) {
        yield PsleLoading();
      } else if (event is _GetPsleCouncilTitle) {
        yield PsleCouncilTitle(await _extractor.getCouncilTitle());
      } else if (event is _GetPsleTitle) {
        yield PsleTitle(await _extractor.getPsleTitle());
      } else if (event is _GetPsleResultYear) {
        yield PsleResultYear(await _extractor.getResultYear());
      } else if (event is _PsleLinkEvent) {
        yield PsleLink(event.link);
      } else if (event is _LoadingCompletedEvent) {
        yield PsleLoadingCompleted();
        complete();
      } else {
        throw MatokeoBlocException('PsleBloc: mapEventToState, unknown event');
      }
    } catch (e) {
      throw MatokeoBlocException(e.toString());
    }
  }
}
