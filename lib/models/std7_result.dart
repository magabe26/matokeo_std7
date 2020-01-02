/**
 * Copyright 2019 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:matokeo_core/matokeo_core.dart' show convertToMap;

class Std7Result extends Equatable {
  final String candidateNo;
  final String sex;
  final String candidateName;
  final String subjects;

  const Std7Result(this.candidateNo, this.sex, this.candidateName, this.subjects);

  @override
  List<Object> get props => [candidateNo, sex, candidateName, subjects];

  Map<String, String> get subjectsMap {
    return convertToMap(subjects, first: ',', second: '-');
  }

  Std7Result copyWith(
      {String candidateNo, String sex, String candidateName, String subjects}) {
    return Std7Result(candidateNo ?? this.candidateNo, sex ?? this.sex,
        candidateName ?? this.candidateName, subjects ?? this.subjects);
  }

  static Std7Result fromJson(Map<String, dynamic> json) {
    return Std7Result(json['CAND. NO'], json['SEX'], json['CANDIDATE NAME'],
        json['SUBJECTS']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'CAND. NO': candidateNo,
      'SEX': sex,
      'CANDIDATE NAME': candidateName,
      'SUBJECTS': subjects
    };
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
