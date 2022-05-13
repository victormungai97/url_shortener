import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:url_shortener/controllers/controller.dart'
    show HTTPController, URLController;

main() {
  final dio = Dio(BaseOptions(baseUrl: URLController.baseURL));
  final dioAdapter = DioAdapter(dio: dio);
  final controller = HTTPController(dio: dio);

  setUp(() {
    dio.httpClientAdapter = dioAdapter;
  });

  group('- HTTPController class methods test', () {
    test('- Get Method Success test', () async {
      const successMessage = {'message': 'Success'};

      dioAdapter.onGet(
        URLController.apiAliasURL,
        (request) {
          return request.reply(200, successMessage);
        },
        data: null,
        queryParameters: {},
        headers: {},
      );

      expect(
        (await controller.request(
          URLController.apiAliasURL,
          method: 'GET',
        ))
            ?.data,
        successMessage,
      );

      expect(
        await controller.baseRequest(
          URLController.apiAliasURL,
          method: 'GET',
          testing: true,
        ),
        successMessage,
      );
    });

    test('- Post Method Success test', () async {
      const successMessage = {'message': 'Success'};

      dioAdapter.onPost(
        URLController.apiAliasURL,
        (request) {
          return request.reply(200, successMessage);
        },
        data: null,
        queryParameters: {},
        headers: {},
      );

      expect(
        (await controller.request(URLController.apiAliasURL))?.data,
        successMessage,
      );

      expect(
        await controller.baseRequest(
          URLController.apiAliasURL,
          testing: true,
        ),
        successMessage,
      );
    });

    test('- 404 Response test', () async {
      dioAdapter.onGet(
        URLController.apiAliasURL,
        (server) => server.throws(
          404,
          DioError(
            requestOptions: RequestOptions(
              path: URLController.apiAliasURL,
            ),
          ),
        ),
      );

      expect(
        () async => await controller.request(
          URLController.apiAliasURL,
          method: 'GET',
        ),
        throwsA(isA<DioError>()),
      );

      expect(
        await controller.baseRequest(
          URLController.apiAliasURL,
          method: 'GET',
          testing: true,
        ),
        isA<String>(),
      );
    });
  });
}
