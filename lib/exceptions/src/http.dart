import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioErrorType.connectTimeout:
        message = "Connection timeout with API server";
        break;
      case DioErrorType.other:
        message = "Check your internet connection and try again";
        break;
      case DioErrorType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioErrorType.response:
        message = _handleError(
            dioError.response?.statusCode ?? 0, dioError.response?.data,
            isAuthUrl: dioError.requestOptions.path.contains('auth'));
        break;
      case DioErrorType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  String? message;

  String _handleError(int statusCode, dynamic error, {bool isAuthUrl = false}) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return isAuthUrl
            ? 'Invalid credentials. Please check username & password and try again'
            : "Unauthorized";
      case 404:
        return error is Map
            ? (error.isNotEmpty ? error['error'] : "Oops!! Page not found")
            : error["message"];
      case 403:
        return 'Session expired, please log in again.';
      case 500:
        return error is String
            ? (error.isNotEmpty ? error : "Internal server error")
            : error["message"];
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message ?? '';
}
