/**
 * Copyright 2019 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'package:matokeo_core/matokeo_core.dart';
import '../models/result_link.dart';

class ResultsLinkDecoder extends Decoder<ResultLink> {
  final String baseUrl;

  ResultsLinkDecoder([this.baseUrl]);

  ///The parsed td element
  ///
  ///   <td>
  ///      <a href="https://www.necta.go.tz/results/2017/psle/results/reg_27.htm">SIMIYU</a>
  ///   </td>
  ///
  @override
  Parser get parser => parentElement('td', element('a'));

  @override
  ResultLink mapParserResult(String result) {
    final name = getElementText(tag: 'a', input: result);
    final href = getAttributeValue(tag: 'a', attribute: 'href', input: result);
    if (name.isNotEmpty && href.isNotEmpty) {
      Map<String, dynamic> map = <String, dynamic>{};
      map['NAME'] = name;
      map['URL'] = (baseUrl != null) ? Urls.getFullUrl(baseUrl, href) : href;
      return ResultLink.fromJson(map);
    }
    return null;
  }
}
