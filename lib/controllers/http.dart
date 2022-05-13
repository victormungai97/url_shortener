part of 'controller.dart';

/// This shall be a base class for HTTP requests made in the app

class HTTPController extends Controller {
  static const _defaultConnectTimeout = Duration.millisecondsPerMinute;
  static const _defaultReceiveTimeout = Duration.millisecondsPerMinute;

  late final Dio _dio;

  HTTPController({Dio? dio}) {
    _dio = dio ?? Dio()
      ..httpClientAdapter;

    _dio
      ..options.baseUrl = URLController.baseURL
      ..options.connectTimeout = _defaultConnectTimeout
      ..options.receiveTimeout = _defaultReceiveTimeout;

    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: true,
          request: true,
          requestBody: true,
        ),
      );
    }
  }

  Future<dynamic> baseRequest(
    String path, {
    String? method = 'POST',
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    bool testing = false,
  }) async {
    try {
      if (!testing) {
        // check internet connection
        final networkStatus = await checkInternetConnection();
        if (networkStatus != null) return networkStatus;
      }

      final response = await request(
        path,
        data: data,
        headers: headers,
        method: method,
        queryParameters: queryParameters,
      );
      if (response == null) return "No response found";

      if (response.statusCode != 200) {
        throw DioExceptions.fromDioError(
          DioError(
            response: response,
            requestOptions: RequestOptions(
              path: path,
              queryParameters: queryParameters,
              headers: headers,
              data: data,
              connectTimeout: _defaultConnectTimeout,
              receiveTimeout: _defaultReceiveTimeout,
            ),
            type: DioErrorType.response,
          ),
        );
      }

      final data1 = response.data;
      if (data1 is Map) debugPrint(prettyPrint(data1));
      if (data1 == null) return "No data received from server";
      return data1;
    } on DioError catch (e) {
      return DioExceptions.fromDioError(e).toString();
    } catch (ex, stackTrace) {
      debugPrint("EXCEPTION:\t$ex\n---\nSTACKTRACE:\t$stackTrace");
      return "Something went wrong. Try again later";
    }
  }

  Future<Response?>? request(
    String path, {
    String? method = 'POST',
    Map<String, dynamic>? queryParameters = const {},
    Map<String, dynamic>? headers = const {},
    data,
  }) async {
    if (headers == null || headers.isEmpty) {
      headers = {'Content-Type': 'application/json; charset=UTF-8'};
    } else {
      if (!headers.containsKey('Content-Type') ||
          !headers.containsKey('content-type')) {
        headers['Content-Type'] = 'application/json; charset=UTF-8';
      }
    }
    _dio.options.headers = headers;

    if (StringUtils.isNullOrEmpty(method)) return null;
    switch (method?.toUpperCase()) {
      case "POST":
        return await _dio.post(
          path,
          data: data,
          queryParameters: queryParameters,
        );
      case "GET":
        return await _dio.get(path, queryParameters: queryParameters);
      case "PUT":
        return await _dio.put(
          path,
          data: data,
          queryParameters: queryParameters,
        );
    }

    return null;
  }

  Future<String?> checkInternetConnection() async {
    try {
      // check for general internet connection
      Response response = await _dio.head('https://google.com');
      if (response.statusCode != 200) {
        return 'Internet not connected';
      }
      // check that shortening website is live
      response = await _dio.head(URLController.baseURL);
      if (response.statusCode != 200) {
        return 'Internet not connected';
      }
      return null;
    } catch (err, stackTrace) {
      debugPrint('EXCEPTION: $err\nStacktrace: $stackTrace');
      return 'Problem connecting to internet';
    }
  }
}
