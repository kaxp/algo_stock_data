import 'dart:io';

import 'package:algo_test/networking/interceptors/request_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';

// default timeout value in milliseconds
const kReceiveTimeout = 60000;
const kConnectTimeout = 60000;

Dio httpClient() {
  final dio = Dio();

  // set default timeout value
  dio.options = BaseOptions(
    receiveTimeout: const Duration(milliseconds: kReceiveTimeout),
    connectTimeout: const Duration(milliseconds: kConnectTimeout),
  );

  dio.interceptors
      .add(LogInterceptor(logPrint: (msg) => debugPrint(msg.toString())));

  dio.interceptors.add(RequestInterceptor());

  // add ssl certificate check
  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
      _onHttpClientCreateWithCertificateCheck;

  return dio;
}

HttpClient _onHttpClientCreateWithCertificateCheck() {
  final securityContext = SecurityContext(withTrustedRoots: true);
  final httpClient = HttpClient(context: securityContext);
  httpClient.badCertificateCallback =
      (X509Certificate cert, String host, int port) => false;
  return httpClient;
}
