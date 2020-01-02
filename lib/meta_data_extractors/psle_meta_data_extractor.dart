/**
 * Copyright 2019 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'meta_data_extractor.dart';
import 'package:meta/meta.dart';

class PSLEMetaDataExtractorException implements Exception {
  String message;
  PSLEMetaDataExtractorException(this.message);

  @override
  String toString() {
    return message;
  }
}

class PSLEMetaDataExtractor extends MetaDataExtractor {
  PSLEMetaDataExtractor(String input) : super(input);

  @override
  String get councilTitleTag => 'h2';

  @override
  String get titleTag => 'h3';

  Future<String> getPsleTitle() => getTitle();

  @override
  String get noTitleFoundMessage => 'No PsleTitle Found';

  @override
  @alwaysThrows
  void throwException([String message]) {
    throw PSLEMetaDataExtractorException(message);
  }
}
