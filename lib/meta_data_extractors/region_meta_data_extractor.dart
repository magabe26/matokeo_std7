/**
 * Copyright 2019 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'meta_data_extractor.dart';
import 'package:meta/meta.dart';
import 'package:matokeo_core/matokeo_core.dart';

class RegionMetaDataExtractorException implements Exception {
  String message;
  RegionMetaDataExtractorException(this.message);

  @override
  String toString() {
    return message;
  }
}

class RegionMetaDataExtractor extends MetaDataExtractor {
  RegionMetaDataExtractor(String input) : super(input);

  @override
  String get councilTitleTag => 'h2';

  @override
  String get titleTag => 'h3';

  Future<String> getRegionTitle() => getTitle();

  Future<String> getRegionName([String regionTitle]) async {
    try {
      var title = (regionTitle != null) ? regionTitle : await getRegionTitle();

      var result = getParserResult(
        parser: spaceOptional()
            .seq(char(','))
            .seq(spaceOptional())
            .seq((letter() | digit() | pattern('-_.,') | whitespace()).star()),
        input: title,
      );

      var region = result.replaceAll(',', '').trim();
      if (region.isNotEmpty) {
        return region;
      } else {
        throwException('No RegiontName Found');
      }
    } catch (_) {
      throwException('No RegionName Found');
    }
  }

  @override
  String get noTitleFoundMessage => 'No RegionTitle Found';

  @override
  @alwaysThrows
  void throwException([String message]) {
    throw RegionMetaDataExtractorException(message);
  }
}
