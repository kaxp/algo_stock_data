import 'package:algo_test/modules/app/base_app_module.dart';
import 'package:algo_test/networking/http_client.dart';
import 'package:algo_test/networking/interceptors/request_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modular_test/modular_test.dart';

void main() {
  late Dio dio;

  setUp(() async {
    initModule(BaseAppModule());
    dio = httpClient();
  });

  test(
      'Given the HTTP client is initialized, '
      'when the client is configured, '
      'then it should contain the correct settings and interceptors.', () {
    // Verify default timeout values
    expect(dio.options.connectTimeout,
        const Duration(milliseconds: kConnectTimeout));
    expect(dio.options.receiveTimeout,
        const Duration(milliseconds: kReceiveTimeout));

    // Verify the presence of LogInterceptor
    final hasLogInterceptor =
        dio.interceptors.any((interceptor) => interceptor is LogInterceptor);
    expect(hasLogInterceptor, isTrue);

    // Verify the presence of RequestInterceptor
    final hasRequestInterceptor = dio.interceptors
        .any((interceptor) => interceptor is RequestInterceptor);
    expect(hasRequestInterceptor, isTrue);
  });
}
