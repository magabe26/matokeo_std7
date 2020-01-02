/**
 * Copyright 2019 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'dart:convert';
import 'package:equatable/equatable.dart';

class ResultLink extends Equatable {
  final String name;
  final String url;

  const ResultLink(this.name, this.url);

  @override
  List<Object> get props => [name, url];

  ResultLink copyWith({String name, String url}) {
    return ResultLink(name ?? this.name, url ?? this.url);
  }

  static ResultLink fromJson(Map<String, dynamic> json) {
    return ResultLink(json['NAME'], json['URL']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'NAME': name, 'URL': url};
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
