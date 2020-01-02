/**
 * Copyright 2019 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';

class GradePerformanceSummaryContent extends Equatable {
  final num gradeA;
  final num gradeB;
  final num gradeC;
  final num gradeD;
  final num gradeE;

  @override
  List<Object> get props => [gradeA, gradeB, gradeC, gradeD, gradeE];

  GradePerformanceSummaryContent({
    @required this.gradeA,
    @required this.gradeB,
    @required this.gradeC,
    @required this.gradeD,
    @required this.gradeE,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'gradeA': gradeA,
      'gradeB': gradeB,
      'gradeC': gradeC,
      'gradeD': gradeD,
      'gradeE': gradeE
    };
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}

class GradePerformanceSummary extends Equatable {
  final GradePerformanceSummaryContent gradePerformanceMale;
  final GradePerformanceSummaryContent gradePerformanceFemale;
  final GradePerformanceSummaryContent gradePerformanceTotal;

  @override
  List<Object> get props =>
      [gradePerformanceFemale, gradePerformanceMale, gradePerformanceTotal];

  GradePerformanceSummary({
    this.gradePerformanceMale,
    this.gradePerformanceFemale,
    this.gradePerformanceTotal,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'gradePerformanceMale': gradePerformanceMale,
      'gradePerformanceFemale': gradePerformanceFemale,
      'gradePerformanceTotal': gradePerformanceTotal,
    };
  }

  @override
  String toString() {
    return 'GradePerformanceSummary${jsonEncode(this)}';
  }
}
