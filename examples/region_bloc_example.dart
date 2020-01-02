/**
 * Copyright 2019 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'package:matokeo_core/matokeo_core.dart' show getCleanedHtml;
import 'package:matokeo_std7/blocs/region_bloc.dart';
import 'package:matokeo_std7/url_managers/std7_results_urls.dart';

const links = [
  'http://localhost/primary/2017/psle/results/psle.htm',
  'http://localhost/primary/2017/psle/results/shl_ps1907062.htm',
  'http://localhost/primary/2017/psle/results/distr_1907.htm',
  'http://localhost/primary/2017/psle/results/reg_19.htm'
];

void run_region_bloc_example() async {
  final url = links[3];

  var regionBloc = RegionBloc();
  regionBloc.listen((state) {
    print(state);
    if (state is DistrictLink) {
      print(state.link);
    }

    if (state is RegionLoading) {
      print('loading....');
    }

    if (state is RegionLoadingCompleted) {
      print('loading completed! ...');
    }

    if (state is RegionName) {
      print(state.regionName);
    }

    if (state is RegionResultYear) {
      print(state.year);
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
    await regionBloc.load(xml, baseUrl: getBaseUrl(url));
  } catch (e) {
    print(e);
  }
}

void main() async {
  run_region_bloc_example();
}
