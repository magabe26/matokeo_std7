/**
 * Copyright 2019 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'package:matokeo_core/matokeo_core.dart' show getCleanedHtml;
import 'package:matokeo_std7/blocs/psle_bloc.dart';
import 'package:matokeo_std7/url_managers/std7_results_urls.dart';

const links = [
  'http://localhost/primary/2017/psle/results/psle.htm',
  'http://localhost/primary/2017/psle/results/shl_ps1907062.htm',
  'http://localhost/primary/2017/psle/results/distr_1907.htm',
  'http://localhost/primary/2017/psle/results/reg_19.htm'
];

void run_psle_bloc_example() async {
  //final url =  'https://onlinesys.necta.go.tz/results/2019/psle/psle.htm';
  final url = links[0];
//final url = 'https://necta.go.tz/results/2017/psle/psle.htm';
  var psleBloc = PsleBloc();

  psleBloc.listen((state) {
    print(state);
    if (state is PsleCouncilTitle) {
      print(state.councilTitle);
    }

    if (state is PsleLink) {
      print(state.link);
    }
    if (state is PsleResultYear) {
      print(state.year);
    }

    if (state is PsleLoading) {
      print('loading....');
    }

    if (state is PsleLoadingCompleted) {
      print('loading completed....');
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
    ], keepAttributes: [
      'HREF'
    ]);

    // await psleBloc.load(xml);
    Future.delayed(Duration(milliseconds: 2000), () {
      psleBloc.load(xml, baseUrl: getBaseUrl(url, isSd7PsleUrl: true));
    });
    Future.delayed(Duration(milliseconds: 2000), () {
      psleBloc.load(xml, baseUrl: getBaseUrl(url, isSd7PsleUrl: true));
    });
    Future.delayed(Duration(milliseconds: 2000), () {
      psleBloc.load(xml, baseUrl: getBaseUrl(url, isSd7PsleUrl: true));
    });
  } catch (e) {
    print(e);
  }
}

void main() async {
  run_psle_bloc_example();
}
