import 'dart:async';

import 'package:dio/dio.dart';
import '../exceptions/app_exceptions.dart';
import 'injection_container.dart';

class DioHelper {
  Dio dio = getDio();

  Options options = Options(
    receiveDataWhenStatusError: true,
    contentType: "application/json",
    responseType: ResponseType.json,
    sendTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  );

  Future<dynamic> getApi({
    required String url,
    bool isAuthRequired = false,
    String? authToken,
  }) async {
    Options requestOptions = isAuthRequired
        ? options.copyWith(
            headers: {
              ...?options.headers,
              "Authorization": "Bearer $authToken",
            },
          )
        : options;

    try {
      Response response = await dio.get(url, options: requestOptions);
      return response.data;
    } on DioException catch (error) {
      _handleDioError(error);
    } catch (error) {
      throw FetchDataException(error.toString());
    }
  }

  Future<dynamic> postApi({
    required String url,
    bool isAuthRequired = false,
    String? authToken,
    Object? requestBody,
  }) async {
    Options requestOptions = isAuthRequired
        ? options.copyWith(
            headers: {
              ...?options.headers,
              "Authorization": "Bearer $authToken",
            },
          )
        : options;

    try {
      Response response = await dio.post(
        url,
        data: requestBody,
        options: requestOptions,
      );

      return response.data;
    } on DioException catch (error) {
      _handleDioError(error);
    } catch (error) {
      return null;
    }
  }

  Future<dynamic> putApi({
    required String url,
    bool isAuthRequired = false,
    Object? requestBody,
    String? authToken,
  }) async {
    Options requestOptions = isAuthRequired
        ? options.copyWith(
            headers: {
              ...?options.headers,
              "Authorization": "Bearer $authToken",
            },
          )
        : options;
    try {
      Response response;
      if (requestBody == null) {
        response = await dio.put(url, options: requestOptions);
      } else {
        response = await dio.put(url, options: options, data: requestBody);
      }
      return response.data;
    } on DioException catch (error) {
      _handleDioError(error);
    } catch (error) {
      return null;
    }
  }

  Future<dynamic> patchApi({
    required String url,
    bool isAuthRequired = false,
    Object? requestBody,
    String? authToken,
  }) async {
    Options requestOptions = isAuthRequired
        ? options.copyWith(
            headers: {
              ...?options.headers,
              "Authorization": "Bearer $authToken",
            },
          )
        : options;

    try {
      Response response;
      if (requestBody == null) {
        response = await dio.patch(url, options: requestOptions);
      } else {
        response = await dio.patch(url, options: options, data: requestBody);
      }
      return response.data;
    } on DioException catch (error) {
      _handleDioError(error);
    } catch (error) {
      return null;
    }
  }

  Future<dynamic> deleteApi({
    required String url,
    bool isAuthRequired = false,
    Object? requestBody,
    String? authToken,
  }) async {
    Options requestOptions = isAuthRequired
        ? options.copyWith(
            headers: {
              ...?options.headers,
              "Authorization": "Bearer $authToken",
            },
          )
        : options;
    try {
      Response response;
      if (requestBody == null) {
        response = await dio.delete(url, options: requestOptions);
      } else {
        response = await dio.delete(url, options: options, data: requestBody);
      }
      return response.data;
    } on DioException catch (error) {
      _handleDioError(error);
    } catch (error) {
      return null;
    }
  }

  void _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw RequestTimeoutException(error.message);
      case DioExceptionType.badResponse:
        final statusCode = error.response?.data['StatusCode'];

        switch (statusCode) {
          case 401:
            throw UnauthorizedException(
              "Session expired. Please log in again to continue.",
            );
          case 4001:
            throw InvalidInputException("The entered OTP is incorrect!");
          case 4002:
            throw InvalidInputException("Invalid Input");
          case 6001:
            throw InvalidInputException("The user already exist!");
          case 4003:
            throw InvalidInputException("Invalid Mobile Number");
          case 4004:
            throw UnauthorizedException("Otp Not Verified");
          case 4005:
            throw UnauthorizedException("Customer not approved");
          case 4006:
            throw TimeoutException("Otp Expired!");
          case 4007:
            throw InvalidInputException("Invalid Otp!");
          case 4008:
            throw NotFoundException("Customer not found");
          case 4009:
            throw InvalidInputException("Password Do Not Match");
          case 4010:
            throw InvalidInputException("InValid Customer");
          case 4011:
            throw InvalidInputException("InValid Login Id");
          case 4012:
            throw InvalidInputException("InValid Order");
          default:
            throw FetchDataException("Error occurred!");
        }
      case DioExceptionType.cancel:
        throw FetchDataException('Request cancelled');
      case DioExceptionType.connectionError:
        throw NoInternetException('No internet connection');
      case DioExceptionType.badCertificate:
        throw FetchDataException('Bad certificate');
      case DioExceptionType.unknown:
        throw FetchDataException('Unknown error occurred');
    }
  }

  /// MULTIPART API
  Future<dynamic> multiPartRequest({
    required String url,
    required Object requestBody,
    bool isAuthRequired = false,
  }) async {
    Options option = Options(headers: {"Content-Type": "multipart/form-data"});

    try {
      Response response = await dio.post(
        url,
        data: requestBody,
        options: option,
      );
      return response.data;
    } on DioException catch (error) {
      _handleDioError(error);
    } catch (error) {
      return null;
    }
  }
}
