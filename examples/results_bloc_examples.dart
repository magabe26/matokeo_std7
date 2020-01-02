/**
 * Copyright 2019 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'package:matokeo_core/matokeo_core.dart' show getCleanedHtml;
import 'package:matokeo_std7/blocs/results_bloc.dart';

const links = [
  'http://localhost/primary/2017/psle/results/psle.htm',
  'http://localhost/primary/2017/psle/results/shl_ps1907062.htm',
  'http://localhost/primary/2017/psle/results/distr_1907.htm',
  'http://localhost/primary/2017/psle/results/reg_19.htm',
  'http://localhost/primary/2019/shl_ps0101008.htm',
  'http://localhost/primary/2019/shl_ps0101008-UPPER.htm'
];

run_results_bloc_example1() async {
  //var url = 'https://onlinesys.necta.go.tz/results/2019/psle/results/shl_ps0201021.htm';
  // var url = links[4]; //lowerCase
  var url = links[5]; //upperCase
  //var url = links[1]; //with no grade performance summary

  ResultsBloc bloc = ResultsBloc();
  bloc.listen((state) {
    // print(state);
    if (state is CouncilTitle) {
      print(state.councilTitle);
    }

    if (state is SchoolName) {
      print('School Name : ${state.schoolName}');
    }
    if (state is SchoolNumber) {
      print('School Number : ${state.schoolNumber}');
    }
    if (state is ResultYear) {
      print('Year : ${state.year}');
    }

    if (state is ResultLoaded) {
      print(state.result);
    }

    if (state is ResultsLoading) {
      print('loading....');
    }
    if (state is ResultsLoadingCompleted) {
      print('loading... completed ...');
    }

    if (state is ResultSummary) {
      print(state.summaryMap);
    }
    if (state is StudentsGradePerformanceSummary) {
      print(state.summary);
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
    await bloc.load(xml);
/*
    Future.delayed(Duration(milliseconds: 2000), () {
      bloc.load(xml);
    });
    Future.delayed(Duration(milliseconds: 3000), () {
      bloc.load(xml);
    });
    Future.delayed(Duration(milliseconds: 4000), () {
      bloc.load(xml);
    });*/
  } catch (e) {
    print(e);
  }
}

run_results_bloc_example2() async {
  ResultsBloc bloc = ResultsBloc();
  bloc.listen((state) {
    // print(state);
    if (state is CouncilTitle) {
      print(state.councilTitle);
    }

    if (state is ResultLoaded) {
      print('${state.result.candidateName} ---- ${state.result.subjectsMap}');
    }
    if (state is ResultSummary) {
      print(state.summaryMap);
    }
    if (state is StudentsGradePerformanceSummary) {
      print(state.summary);
    }
    if (state is ResultsLoading) {
      print('loading....');
    }

    if (state is ResultsLoadingCompleted) {
      print('loading... completed ...');
    }
  }, onError: (e) {
    print('Error -> ${e.toString()}');
  });

  try {
    var xml = await getCleanedHtml(links[4], keepTags: const <String>[
      'a',
      'td',
      'h1',
      'h2',
      'h3',
      'table',
      'body',
      'tr'
    ]);
    await bloc.load(xml);
  } catch (e) {
    print(e);
  }
}

void main() async {
  run_results_bloc_example1();
  //run_results_bloc_example2();
}
