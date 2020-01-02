/**
 * Copyright 2019 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'package:matokeo_core/matokeo_core.dart';
import 'package:matokeo_std7/decoders/results_decoder.dart';
import 'package:matokeo_std7/decoders/results_link_decoder.dart';
import 'package:matokeo_std7/meta_data_extractors/district_meta_data_extractor.dart';
import 'package:matokeo_std7/meta_data_extractors/psle_meta_data_extractor.dart';
import 'package:matokeo_std7/meta_data_extractors/region_meta_data_extractor.dart';
import 'package:matokeo_std7/meta_data_extractors/result_meta_data_extractor.dart';
import 'package:matokeo_std7/models/result_link.dart';
import 'package:matokeo_std7/models/std7_result.dart';

const links = [
  'http://localhost/primary/2017/psle/results/psle.htm',
  'http://localhost/primary/2017/psle/results/shl_ps1907062.htm',
  'http://localhost/primary/2017/psle/results/distr_1907.htm',
  'http://localhost/primary/2017/psle/results/reg_19.htm'
];

void run_results_link_decoder_example(int forUrlIndex) async {
  try {
    var xml = await getCleanedHtml(links[forUrlIndex], keepTags: const <String>[
      'a',
      'td',
      'h1',
      'h2',
      'h3',
      'table',
      'body',
      'tr'
    ]);

    //print(html);

    stringToStream(xml)
        .transform(ResultsLinkDecoder(Urls.getBaseUrl(links[forUrlIndex])))
        .expand((i) => i)
        .listen((ResultLink link) {
      print(link);
    });
  } on GetCleanedHtmlFailed catch (e) {
    print(e);
  } catch (e) {
    print(e);
  }
}

void run_results_decoder_example() async {
  try {
    var xml = await getCleanedHtml(links[1], keepTags: const <String>[
      'a',
      'td',
      'h1',
      'h2',
      'h3',
      'table',
      'body',
      'tr'
    ]);
    ResultsDecoder().decode(xml).listen((Std7Result r) {
      print(r.candidateNo);
    });
  } on GetCleanedHtmlFailed catch (e) {
    print(e);
  } catch (e) {
    print(e);
  }
}

psle_links() => run_results_link_decoder_example(0);
district_links() => run_results_link_decoder_example(2);
region_links() => run_results_link_decoder_example(3);

run_result_meta_data_extractor_example() async {
  try {
    var xml = await getCleanedHtml(links[1], keepTags: const <String>[
      'a',
      'td',
      'h1',
      'h2',
      'h3',
      'table',
      'body',
      'tr'
    ]);

    // print(xml);
    var extractor = ResultMetaDataExtractor(xml);

    var summary = await extractor.getResultsSummary();
    print(summary);

    var summaryMap = await extractor.getResultsSummaryMap();
    print(summaryMap);

    var councilTitle = await extractor.getCouncilTitle();
    print(councilTitle);

    var resultsTitle = await extractor.getResultsTitle();
    print(resultsTitle);

    var school = await extractor.getSchool();
    print(school);

    var schoolNumber = await extractor.getSchoolNumber();
    print(schoolNumber);

    var schoolName = await extractor.getSchoolName();
    print(schoolName);

    var year = await extractor.getResultYear();
    print(year);
  } on GetCleanedHtmlFailed catch (e) {
    print(e);
  } catch (e) {
    print(e);
  }
}

run_PSLE_meta_data_extractor() async {
  try {
    var xml = await getCleanedHtml(links[0], keepTags: const <String>[
      'a',
      'td',
      'h1',
      'h2',
      'h3',
      'table',
      'body',
      'tr'
    ]);

    //print(html);

    var extractor = PSLEMetaDataExtractor(xml);

    var year = await extractor.getResultYear();
    print(year);

    var title = await extractor.getPsleTitle();
    print(title);

    var ctitle = await extractor.getCouncilTitle();
    print(ctitle);
  } on GetCleanedHtmlFailed catch (e) {
    print(e);
  } catch (e) {
    print(e);
  }
}

run_district_meta_data_extractor() async {
  try {
    var xml = await getCleanedHtml(links[2], keepTags: const <String>[
      'a',
      'td',
      'h1',
      'h2',
      'h3',
      'table',
      'body',
      'tr'
    ]);

    //print(html);

    var extractor = DistrictMetaDataExtractor(xml);

    var year = await extractor.getResultYear();
    print(year);

    var title = await extractor.getDistrictTitle();
    print(title);

    var ctitle = await extractor.getCouncilTitle();
    print(ctitle);

    var districtName = await extractor.getDistrictName();
    print(districtName);
  } on GetCleanedHtmlFailed catch (e) {
    print(e);
  } catch (e) {
    print(e);
  }
}

run_region_meta_data_extractor() async {
  try {
    var xml = await getCleanedHtml(links[3], keepTags: const <String>[
      'a',
      'td',
      'h1',
      'h2',
      'h3',
      'table',
      'body',
      'tr'
    ]);

    //print(html);

    var extractor = RegionMetaDataExtractor(xml);

    var year = await extractor.getResultYear();
    print(year);

    var title = await extractor.getRegionTitle();
    print(title);

    var ctitle = await extractor.getCouncilTitle();
    print(ctitle);

    var regionName = await extractor.getRegionName();
    print(regionName);
  } on GetCleanedHtmlFailed catch (e) {
    print(e);
  } catch (e) {
    print(e);
  }
}

run_get_grade_performance_summary() async {
  try {
    var xml = await getCleanedHtml(
        'http://localhost/primary/2019/shl_ps0101008.htm',
        dirtyTags: <DirtyTag>{
          DirtyTag(start: '<style>', end: '</style>')
        },
        keepTags: const <String>[
          'a',
          'td',
          'h1',
          'h2',
          'h3',
          'table',
          'body',
          'tr'
        ]);

    //print(xml);
    var extractor = ResultMetaDataExtractor(xml);
    var grade = await extractor.getGradePerformanceSummary();
    print(grade);
    //print(await extractor.getStudentsGradePerformanceSummaryXml());
  } on GetCleanedHtmlFailed catch (e) {
    print(e);
  } catch (e) {
    print(e);
  }
}

void main() async {
  /*------------links--------------*/

  //psle_links();
  //district_links();
  //region_links();

  /*-------------------------results-------------*/
  run_results_decoder_example();

  //run_result_meta_data_extractor_example();

  // run_PSLE_meta_data_extractor();

  //run_district_meta_data_extractor();

  // run_region_meta_data_extractor();

  //run_get_grade_performance_summary();
}
