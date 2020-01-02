/**
 * Copyright 2019 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'package:matokeo_core/matokeo_core.dart';
import 'package:matokeo_std7/blocs/district_bloc.dart';
import 'package:matokeo_std7/url_managers/std7_results_urls.dart';

const links = [
  'http://localhost/primary/2017/psle/results/psle.htm',
  'http://localhost/primary/2017/psle/results/shl_ps1907062.htm',
  'http://localhost/primary/2017/psle/results/distr_1907.htm',
  'http://localhost/primary/2017/psle/results/reg_19.htm'
];

run_district_bloc_example() async {
  final url = links[2];

  //final url = 'https://necta.go.tz/results/2017/psle/results/reg_18.htm';

  DistrictBloc districtBloc = DistrictBloc();

  districtBloc.listen((state) {
    print(state);
    if (state is SchoolLink) {
      print(state.link.url);
    }

    if (state is DistrictLoading) {
      print('loading....');
    }

    if (state is DistrictName) {
      print(state.districtName);
    }

    if (state is DistrictCouncilTitle) {
      print(state.councilTitle);
    }

    if (state is DistrictResultYear) {
      print(state.year);
    }

    if (state is DistrictLoadingCompleted) {
      print('loading completed!');
    }
  }, onError: (e) {
    print('Error -> ${e.toString()}');
  });

  try {
    var xml = await getCleanedHtml(url, keepTags: const <String>[
      'a',
      'td',
      'h1',
      'h2',
      'h3',
      'table',
      'body',
      'tr'
    ]);
    await districtBloc.load(xml, baseUrl: getBaseUrl(url));
  } catch (e) {
    print(e);
  }
}

void main() async {
  run_district_bloc_example();
}
