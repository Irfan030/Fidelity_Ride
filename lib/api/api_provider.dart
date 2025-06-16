import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'api_url.dart';
String?bearerToken;
class APIResponse {
  String? message;
  dynamic responseBody;
  int? responseCode;

  APIResponse({this.message, this.responseBody, this.responseCode});
}

class APIProvider {
  late Dio _client;
  static APIProvider get instance => APIProvider();

  APIProvider() {
    _client = Dio(BaseOptions(baseUrl: ApiUrl.devUrl));
    _client.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
    ));
    _updateHeaders();
  }

  void _updateHeaders() {
    _client.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${bearerToken?.toString() ?? ''}'
    };
  }

  Future<bool> _isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<APIResponse> _handleNetworkCheck(Future<Response> Function() apiCall) async {
    if (await _isConnected()) {
      try {
        final response = await apiCall();
        return _handleAPIResponse(response);
      } on DioError catch (e) {
        return _handleAPIException(e);
      } catch (e) {
        return APIResponse(message: 'An unexpected error occurred');
      }
    } else {
      return APIResponse(message: 'No internet connection');
    }
  }

  Future<APIResponse> get(String endPoint) async {
    return _handleNetworkCheck(() => _client.get(endPoint));
  }

  Future<APIResponse> post(String endPoint, dynamic body) async {
    return _handleNetworkCheck(() => _client.post(endPoint, data: body));
  }

  Future<APIResponse> delete(String endPoint) async {
    return _handleNetworkCheck(() => _client.delete(endPoint));
  }

  APIResponse _handleAPIResponse(Response response) {
    if (response.statusCode == 200) {
      return APIResponse(
        responseBody: response.data,
        responseCode: response.statusCode,
      );
    } else {
      return APIResponse(
        message: 'Something went wrong [Error Code: ${response.statusCode}]',
        responseCode: response.statusCode,
      );
    }
  }

  APIResponse _handleAPIException(DioError e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return APIResponse(message: 'Connection timeout');
      case DioExceptionType.receiveTimeout:
        return APIResponse(message: 'Receive timeout');
      case DioExceptionType.sendTimeout:
        return APIResponse(message: 'Send timeout');
      case DioExceptionType.badResponse:
        return APIResponse(
          message: e.response?.statusMessage ?? 'Bad response',
          responseCode: e.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return APIResponse(message: 'Request was cancelled');
      case DioExceptionType.connectionError:
        return APIResponse(message: 'Network connection error');
      case DioExceptionType.unknown:
      default:
        if (e.error is SocketException) {
          return APIResponse(message: 'No internet connection');
        } else {
          return APIResponse(message: 'Unexpected error occurred');
        }
    }
  }

}
