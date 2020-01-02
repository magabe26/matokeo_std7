/**
 * Copyright 2019 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'package:matokeo_core/matokeo_core.dart';
import '../models/std7_result.dart';

class ResultsDecoder extends Decoder<Std7Result> {
  final int tdElementCount = 4;

  ///The parsed tr element
  ///
  ///   <tr>
  ///      <td>PS1907062-024</td>
  ///      <td>M</td>
  ///      <td>MAGABE LAB</td>
  ///      <td>Kiswahili - A, English - A, Maarifa - A, Hisabati - A, Science - A, Average Grade - A</td>
  ///    </tr>
  ///
  @override
  Parser get parser =>
      parentElement('tr', repeat(element('td'), tdElementCount));

  @override
  Std7Result mapParserResult(String result) {
    final tdElements = getParserResults(parser: element('td'), input: result);

    if (tdElements.length == tdElementCount) {
      final cNo = getElementText(tag: 'td', input: tdElements[0]);
      final sex = getElementText(tag: 'td', input: tdElements[1]);
      final cName = getElementText(tag: 'td', input: tdElements[2]);
      final subjects = getElementText(tag: 'td', input: tdElements[3]);

      //Skipping the Header "tr"
      if ('SEX' != sex.toUpperCase()) {
        var map = <String, dynamic>{};
        map['CAND. NO'] = cNo;
        map['SEX'] = sex;
        map['CANDIDATE NAME'] = cName;
        map['SUBJECTS'] = subjects;
        return Std7Result.fromJson(map);
      }
    }
    return null;
  }
}
