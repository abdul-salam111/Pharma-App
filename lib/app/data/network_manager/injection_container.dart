import 'dart:convert';
import 'package:dio/dio.dart';
import 'prints.dart';

Dio getDio() {
  Dio dio = Dio();

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        printValue(tag: 'API URL:', '${options.uri}');
        printValue(tag: 'HEADER:', options.headers);
        try {
          printValue(tag: 'REQUEST BODY:', jsonEncode(options.data));
        } catch (e) {
          printValue(tag: "Request Body", e.toString());
        }
        return handler.next(options);
      },

      onResponse: (Response response, ResponseInterceptorHandler handler) {
        printValue(tag: 'API RESPONSE:', response.data);

        return handler.next(response);
      },

      onError: (DioException e, ErrorInterceptorHandler handler) {
        printValue(tag: 'STATUS CODE:', "${e.response?.statusCode ?? ""}");
        printValue(tag: 'ERROR DATA:', "${e.response?.data ?? ""}");

        return handler.next(e);
      },
    ),
  );

  return dio;
}
