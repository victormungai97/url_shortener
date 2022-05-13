/// This file exposes the controllers in the folder
/// These controllers are where actual business logic eg server calls will happen

import 'package:basic_utils/basic_utils.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:validators/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:url_shortener/models/model.dart';
import 'package:url_shortener/exceptions/exception.dart';

part 'urls.dart';

part 'http.dart';

part 'link.dart';

abstract class Controller extends Equatable {
  const Controller();

  @override
  List<Object> get props => [];

  /// Convert json to a readable form

  String prettyPrint(Map json) {
    if (json.isEmpty) return "";
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String pretty = encoder.convert(json);
    return pretty;
  }
}
