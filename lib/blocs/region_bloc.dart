/**
 * Copyright 2019 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:matokeo_core/matokeo_core.dart';

import '../meta_data_extractors/region_meta_data_extractor.dart';
import '../decoders/results_link_decoder.dart';
import '../models/result_link.dart';

/*------------States------------------------*/

class RegionState {}

class RegionLoading extends RegionState {}

class RegionLoadingCompleted extends RegionState {}

class RegionCouncilTitle extends RegionState with EquatableMixin {
  final String councilTitle;

  RegionCouncilTitle(this.councilTitle);

  @override
  List<Object> get props => [councilTitle];
}

class RegionTitle extends RegionState with EquatableMixin {
  final String regionTitle;

  RegionTitle(this.regionTitle);

  @override
  List<Object> get props => [regionTitle];
}

class RegionName extends RegionState with EquatableMixin {
  final String regionName;

  RegionName(this.regionName);

  @override
  List<Object> get props => [regionName];
}

class RegionResultYear extends RegionState with EquatableMixin {
  final int year;

  RegionResultYear(this.year);

  @override
  List<Object> get props => [year];
}

class DistrictLink extends RegionState with EquatableMixin {
  final ResultLink link;

  DistrictLink(this.link);

  @override
  List<Object> get props => [link];
}

/*------------Events------------------------*/
class _RegionEvent {}

class _GetRegionCouncilTitle extends _RegionEvent {}

class _GetRegionTitle extends _RegionEvent {}

class _GetRegionName extends _RegionEvent {}

class _GetRegionResultYear extends _RegionEvent {}

class _RegionLoadingEvent extends _RegionEvent {}

class _DistrictLinkEvent extends _RegionEvent with EquatableMixin {
  final ResultLink link;

  _DistrictLinkEvent(this.link);

  @override
  List<Object> get props => [link];
}

class _LoadingCompletedEvent extends _RegionEvent {}

/*-------------------Bloc--------------------------*/

class RegionBloc extends DecoderBloc<_RegionEvent, RegionState> {
  RegionMetaDataExtractor _extractor;

  @override
  void dispatchEvents(String input, {String baseUrl}) {
    dispatchEvent(_RegionLoadingEvent());

    _extractor = RegionMetaDataExtractor(input ?? '');

    decode(
        input: input,
        decoder: ResultsLinkDecoder(baseUrl),
        listener: (link) {
          dispatchEvent(_DistrictLinkEvent(link));
        },
        onDone: () {
          dispatchEvent(_GetRegionCouncilTitle());

          dispatchEvent(_GetRegionName());

          dispatchEvent(_GetRegionTitle());

          dispatchEvent(_GetRegionResultYear());

          //complete event
          dispatchEvent(_LoadingCompletedEvent());
        });
  }

  @override
  Stream<RegionState> mapEventToState(_RegionEvent event) async* {
    try {
      if (event is _RegionLoadingEvent) {
        yield RegionLoading();
      } else if (event is _GetRegionCouncilTitle) {
        yield RegionCouncilTitle(await _extractor.getCouncilTitle());
      } else if (event is _GetRegionTitle) {
        yield RegionTitle(await _extractor.getRegionTitle());
      } else if (event is _GetRegionResultYear) {
        yield RegionResultYear(await _extractor.getResultYear());
      } else if (event is _GetRegionName) {
        yield RegionName(await _extractor.getRegionName());
      } else if (event is _DistrictLinkEvent) {
        yield DistrictLink(event.link);
      } else if (event is _LoadingCompletedEvent) {
        yield RegionLoadingCompleted();
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
