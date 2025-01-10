import 'dart:io';

import 'package:algo_test/constants/app_strings.dart';
import 'package:dio/dio.dart';

extension DioExceptionExt on DioException {
  String errorMessage() {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return AppStrings.networkErrorMessage;
      case DioExceptionType.cancel:
        return AppStrings.networkRequestCanceled;
      case DioExceptionType.badCertificate:
        return AppStrings.invalidClientIdError;
      case DioExceptionType.badResponse:
        return _getMessageFromDioExceptionType(this);
      case DioExceptionType.unknown:
        return message ?? AppStrings.unknownError;
    }
  }

  String _getMessageFromDioExceptionType(DioException dioException) {
    switch (dioException.error.runtimeType) {
      case SocketException:
        return AppStrings.networkErrorMessage;
      default:
        return AppStrings.unknownError;
    }
  }
}
