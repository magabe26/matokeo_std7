/**
 * Copyright 2019 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'package:meta/meta.dart';
import 'meta_data_extractor.dart';
import 'package:matokeo_core/matokeo_core.dart';

class DistrictMetaDataExtractorException implements Exception {
  String message;
  DistrictMetaDataExtractorException(this.message);

  @override
  String toString() {
    return message;
  }
}

class DistrictMetaDataExtractor extends MetaDataExtractor {
  DistrictMetaDataExtractor(String input) : super(input);

  @override
  String get councilTitleTag => 'h2';

  @override
  String get titleTag => 'h3';

  Future<String> getDistrictTitle() => getTitle();

  Future<String> getDistrictName([String districtTitle]) async {
    Future<String> _t() => (districtTitle != null)
        ? Future<String>.value(districtTitle)
        : getDistrictTitle();

    try {
      var title = await _t();
      var result = getParserResult(
        parser: spaceOptional()
            .seq(char(','))
            .seq(spaceOptional())
            .seq((letter() | digit() | pattern('-_.,') | whitespace()).star()),
        input: title,
      );

      var district = result.replaceAll(',', '').trim();
      if (district.isNotEmpty) {
        return district;
      } else {
        throwException('No DistrictName Found');
      }
    } catch (_) {
      throwException('No DistrictName Found');
    }
  }

  @override
  String get noTitleFoundMessage => 'No DistrictTitle Found';

  @override
  @alwaysThrows
  void throwException([String message]) {
    throw DistrictMetaDataExtractorException(message);
  }
}
