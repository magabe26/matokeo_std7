/**
 * Copyright 2019 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:matokeo_core/matokeo_core.dart';

import '../decoders/results_link_decoder.dart';
import '../meta_data_extractors/district_meta_data_extractor.dart';
import '../models/result_link.dart';

/*-------------------States--------------------------*/

class DistrictState {}

class DistrictLoading extends DistrictState {}

class DistrictLoadingCompleted extends DistrictState {}

class DistrictCouncilTitle extends DistrictState with EquatableMixin {
  final String councilTitle;

  DistrictCouncilTitle(this.councilTitle);

  @override
  List<Object> get props => [councilTitle];
}

class DistrictTitle extends DistrictState with EquatableMixin {
  final String districtTitle;

  DistrictTitle(this.districtTitle);

  @override
  List<Object> get props => [districtTitle];
}

class DistrictName extends DistrictState with EquatableMixin {
  final String districtName;

  DistrictName(this.districtName);

  @override
  List<Object> get props => [districtName];
}

class DistrictResultYear extends DistrictState with EquatableMixin {
  final int year;

  DistrictResultYear(this.year);

  @override
  List<Object> get props => [year];
}

class SchoolLink extends DistrictState with EquatableMixin {
  final ResultLink link;

  SchoolLink(this.link);

  @override
  List<Object> get props => [link];
}

/*------------Events------------------------*/
class _DistrictEvent {}

class _GetDistrictCouncilTitle extends _DistrictEvent {}

class _GetDistrictTitle extends _DistrictEvent {}

class _GetDistrictName extends _DistrictEvent {}

class _GetDistrictResultYear extends _DistrictEvent {}

class _DistrictLoadingEvent extends _DistrictEvent {}

class _SchoolLinkEvent extends _DistrictEvent with EquatableMixin {
  final ResultLink link;

  _SchoolLinkEvent(this.link);

  @override
  List<Object> get props => [link];
}

class _LoadingCompletedEvent extends _DistrictEvent {}

/*-------------------Bloc--------------------------*/

class DistrictBloc extends DecoderBloc<_DistrictEvent, DistrictState> {
  DistrictMetaDataExtractor _extractor;

  @override
  void dispatchEvents(String input, {String baseUrl}) {
    dispatchEvent(_DistrictLoadingEvent());

    _extractor = DistrictMetaDataExtractor(input);

    decode(
        input: input,
        decoder: ResultsLinkDecoder(baseUrl),
        listener: (link) {
          dispatchEvent(_SchoolLinkEvent(link));
        },
        onDone: () {
          dispatchEvent(_GetDistrictCouncilTitle());

          dispatchEvent(_GetDistrictName());

          dispatchEvent(_GetDistrictTitle());

          dispatchEvent(_GetDistrictResultYear());

          //complete event
          dispatchEvent(_LoadingCompletedEvent());
        });
  }

  @override
  Stream<DistrictState> mapEventToState(_DistrictEvent event) async* {
    try {
      if (event is _DistrictLoadingEvent) {
        yield DistrictLoading();
      } else if (event is _GetDistrictCouncilTitle) {
        yield DistrictCouncilTitle(await _extractor.getCouncilTitle());
      } else if (event is _GetDistrictTitle) {
        yield DistrictTitle(await _extractor.getDistrictTitle());
      } else if (event is _GetDistrictResultYear) {
        yield DistrictResultYear(await _extractor.getResultYear());
      } else if (event is _GetDistrictName) {
        yield DistrictName(await _extractor.getDistrictName());
      } else if (event is _SchoolLinkEvent) {
        yield SchoolLink(event.link);
      } else if (event is _LoadingCompletedEvent) {
        yield DistrictLoadingCompleted();
        //must call this to be able to reload or load other xml using this block
        complete();
      } else {
        throw MatokeoBlocException(
            'DistrictBloc: mapEventToState, unknown event');
      }
    } catch (e) {
      throw MatokeoBlocException(e.toString());
    }
  }
}
