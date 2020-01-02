/**
 * Copyright 2019 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'package:matokeo_core/matokeo_core.dart';
import 'package:xml/xml.dart' as xml;
import '../models/grade_performance_summary.dart';
import 'package:meta/meta.dart';
import 'meta_data_extractor.dart';

class ResultMetaDataExtractorException implements Exception {
  String message;
  ResultMetaDataExtractorException(this.message);

  @override
  String toString() {
    return message;
  }
}

class ResultMetaDataExtractor extends MetaDataExtractor {
  final String schoolTag = 'h3';

  @override
  String get councilTitleTag => 'h2';

  @override
  String get titleTag => 'h1';

  ResultMetaDataExtractor(String input) : super(input);

  Future<String> getResultsSummary() {
    //summaryItem eg ;-   WALIOFANYA MTIHANI : 64
    final Parser summaryItemParser = any()
        .starLazy(char(':'))
        .seq(char(':'))
        .seq(any().starLazy(char('\n')))
        .seq(char('\n'));

    final summary = getParserResults(
      //return list of summaryItem
      parser: summaryItemParser,
      input: getElementText(
          //get the unformatted summary text
          tag: 'body',
          input: getParserResult(
            //after remove search for body element
            parser: element('body'),
            input: remove(
              //remove those element
              parsers: [
                tableParser(),
                councilTitleParser(),
                resultsTitleParser(),
                schoolParser()
              ],
              input: input,
            ),
          )),
    )
        .map((str) => str.trim())
        .join('\n')
        .trim(); //finally map the list of summaryItem to trim, and join to a new line separated string

    if (summary.isEmpty) {
      throwException('No Summary Found');
    } else {
      return Future.value(summary);
    }
  }

  Future<Map<String, String>> getResultsSummaryMap() async {
    try {
      var summary = await getResultsSummary();
      return convertToMap(summary, first: '\n', second: ':');
    } catch (_) {
      return <String, String>{};
    }
  }

  Future<String> getResultsTitle() => getTitle();

  Future<String> getSchool() {
    try {
      final String school = getElementText(
          tag: schoolTag,
          input: getParserResult(
            parser: schoolParser(),
            input: input,
          ));

      if (school.isEmpty) {
        throwException('No School Found');
      }

      final isNotSchool = school.contains('EXAMINATION RESULTS');
      if (isNotSchool) {
        throwException('No School Found');
      }
      return Future.value(school);
    } catch (_) {
      throwException('No School Found');
    }
  }

  Future<String> getSchoolNumber([String school]) async {
    //because _s is a closer , i must use Future<String>.value
    Future<String> _s() =>
        (school != null) ? Future<String>.value(school) : getSchool();
    try {
      var schl = await _s();
      var result = getParserResult(
        parser: spaceOptional()
            .seq(char('-'))
            .seq(spaceOptional())
            .seq((letter().plus() | digit()).star()),
        input: schl,
      );

      var schoolNumber = result.replaceAll('-', '').trim();
      if (schoolNumber.isEmpty) {
        throwException('No SchoolNumber Found');
      }
      return schoolNumber;
    } catch (_) {
      throwException('No SchoolNumber Found');
    }
  }

  Future<String> getSchoolName([String school]) async {
    Future<String> _s() =>
        (school != null) ? Future<String>.value(school) : getSchool();

    try {
      var schoolName = remove(
        parsers: [
          spaceOptional()
              .seq(char('-'))
              .seq(spaceOptional())
              .seq((letter().plus() | digit()).star())
        ],
        input: await _s(),
      );
      if (schoolName.isEmpty) {
        throwException('No SchoolName Found');
      }
      return schoolName;
    } catch (_) {
      throwException('No SchoolName Found');
    }
  }

  Future<String> getStudentsGradePerformanceSummaryXml() async {
    var summary = getParserResult(
      parser: studentsGradePerformanceSummaryParser(),
      input: input,
    );
    if (summary.isNotEmpty) {
      return summary;
    } else {
      throwException('Students Grade Performance Summary is not found!');
    }
  }

  Parser tableParser() =>
      element('table', startTag: tableStartTagCompletedOrNotParser()).flatten();

  ///This match both '<table>' and that with a ug ie '<table'
  Parser tableStartTagCompletedOrNotParser() => start()
      .seq(nonCaseSensitiveChars('table'))
      .seq(spaceOptional())
      .seq(end().star());

  Parser councilTitleParser() => element(councilTitleTag);

  Parser resultsTitleParser() => element(titleTag);

  Parser schoolParser() => element(schoolTag);

//parsed data //students grade performance summary

// table>

//    <tr>
//      <td>
//
//JINSI</td>
//      <td>
//A</td>
//      <td>
//B</td>
//      <td>
//C</td>
//      <td>
//D</td>
//      <td>
//E</td>
//    </tr>

//    <tr>
//      <td>
//
//WASICHANA</td>
//      <td>
//0</td>
//      <td>
//29</td>
//      <td>
//7</td>
//      <td>
//7</td>
//      <td>
//2</td>
//    </tr>

//    <tr>
//      <td>
//
//WAVULANA</td>
//      <td>
//1</td>
//      <td>
//4</td>
//      <td>
//13</td>
//      <td>
//1</td>
//      <td>
//0</td>
//    </tr>

//    <tr>
//      <td>
//
//JUMLA</td>
//      <td>
//1</td>
//      <td>
//33</td>
//      <td>
//20</td>
//      <td>
//8</td>
//      <td>
//2</td>
//    </tr>

//  </table>

  Parser studentsGradePerformanceSummaryParser() {
    var tr = studentsGradePerformanceSummaryContentParser();
    var _4trs = repeat(tr, 4); //(tr & tr & tr & tr);
    final tableStartTag = tableStartTagCompletedOrNotParser();
    return parentElement('table', _4trs, startTag: tableStartTag).flatten();
  }

  Parser studentsGradePerformanceSummaryContentParser() {
    var _6tds = repeat(element('td'), 6);
    return spaceOptional().seq(parentElement('tr', _6tds)).seq(spaceOptional());
  }

  Future<GradePerformanceSummary> getGradePerformanceSummary() async {
    try {
      var summaryXml = await getStudentsGradePerformanceSummaryXml();

      var trList = getParserResults(
          parser: studentsGradePerformanceSummaryContentParser(),
          input: summaryXml);

      if (trList.isNotEmpty) {
        GradePerformanceSummaryContent femaleGrade;
        GradePerformanceSummaryContent maleGrade;
        GradePerformanceSummaryContent totalGrade;

        int trIndex = 0;
        for (var gradeXml in trList) {
          var doc = xml.parse(gradeXml);
          var tdElements =
              NonCaseSensitiveXmlElementsFinder.findAllElements(doc, 'td');

          if (tdElements.isEmpty) {
            throwException('1. Students Grade Performance Summary not found!');
          }

          if (trIndex != 0) {
            if (tdElements.length != 6) {
              throwException(
                  '2. Students Grade Performance Summary not found!');
            }
            num gradeA = 0;
            num gradeB = 0;
            num gradeC = 0;
            num gradeD = 0;
            num gradeE = 0;
            int identiferer = -1;

            int getIdentiferer(String text) {
              var txtUpperCase = text.toUpperCase();
              if ((txtUpperCase == 'WASICHANA') ||
                  (txtUpperCase == 'F') ||
                  (txtUpperCase == 'FEMALE')) {
                return 0;
              } else if ((txtUpperCase == 'WAVULANA') ||
                  (txtUpperCase == 'M') ||
                  (txtUpperCase == 'MALE')) {
                return 1;
              } else if ((txtUpperCase == 'JUMLA') ||
                  (txtUpperCase == 'TOTAL')) {
                return 2;
              } else {
                return -1;
              }
            }

            int tdIndex = 0;
            for (var td in tdElements) {
              final txt = td.text.trim();
              num grade = 0;
              if (tdIndex != 0) {
                try {
                  grade = num.parse(txt);
                } catch (_) {}
              }

              switch (tdIndex) {
                case 0:
                  identiferer = getIdentiferer(txt);
                  break;
                case 1:
                  gradeA = grade;
                  break;
                case 2:
                  gradeB = grade;
                  break;
                case 3:
                  gradeC = grade;
                  break;
                case 4:
                  gradeD = grade;
                  break;
                case 5:
                  gradeE = grade;
                  break;
              }
              tdIndex++;
            }

            var gsc = GradePerformanceSummaryContent(
                gradeA: gradeA,
                gradeB: gradeB,
                gradeC: gradeC,
                gradeD: gradeD,
                gradeE: gradeE);

            if (identiferer == 0) {
              femaleGrade = gsc;
            } else if (identiferer == 1) {
              maleGrade = gsc;
            } else if (identiferer == 2) {
              totalGrade = gsc;
            }
          }

          trIndex++;
        }

        if ((femaleGrade != null) &&
            (maleGrade != null) &&
            (totalGrade != null)) {
          return GradePerformanceSummary(
              gradePerformanceFemale: femaleGrade,
              gradePerformanceMale: maleGrade,
              gradePerformanceTotal: totalGrade);
        } else {
          throwException('3. Students Grade Performance Summary not found!');
        }
      } else {
        throwException('4. Students Grade Performance Summary not found!');
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  String get noTitleFoundMessage => 'No ResultsTitle Found';

  @override
  @alwaysThrows
  void throwException([String message]) {
    throw ResultMetaDataExtractorException(message);
  }
}
