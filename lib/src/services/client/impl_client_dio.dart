import 'dart:convert';
import 'dart:typed_data';
import 'package:agente_clisitef/src/services/client/clien_exports.dart';
import 'package:agente_clisitef/src/services/log/log.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ClientDio implements IClient {
  late final Dio _dio;
  late Logger _logger;
  final bool enableLogs;
  final bool saveLogsInDirectory;

  ClientDio({BaseOptions? baseOptions, this.enableLogs = false, this.saveLogsInDirectory = false, int? clearLogInDays}) {
    _dio = Dio(baseOptions ?? _defaultOptions);
    _logger = WbaLogs().logger(logName: 'clisitef_requests', saveOnDirectory: saveLogsInDirectory, clearLogInDays: clearLogInDays);
  }

  final _defaultOptions = BaseOptions(baseUrl: 'hhtps://localhost:8080');

  @override
  IClient auth() {
    _defaultOptions.extra["auth_required"] = true;
    return this;
  }

  @override
  IClient unauth() {
    _defaultOptions.extra["auth_required"] = false;
    return this;
  }

  @override
  Future<ClientResponse<T>> delete<T>(String path, {data, Map<String, dynamic>? query, Map<String, dynamic>? headers}) async {
    try {
      _logInfo(path, "DELETE", queryParamters: query, headers: headers, baseOptions: _dio.options.headers, data: data);
      final DateTime start = DateTime.now();
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: query,
        options: Options(headers: headers),
      );
      final DateTime end = DateTime.now();
      _logResponse(path, "DELETE", response: response, time: end.difference(start).inMilliseconds.toString());
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  Future<ClientResponse<T>> download<T>(String path, String savePath,
      {Map<String, dynamic>? query,
      Map<String, dynamic>? headers,
      void Function(int, int)? onReceiveProgress,
      void Function(double percent)? onReceiveProgressPercent}) async {
    try {
      _logInfo(path, "DOWNLOAD", queryParamters: query, headers: headers, baseOptions: _dio.options.headers);
      final DateTime start = DateTime.now();
      final response = await _dio.download(
        path,
        savePath,
        onReceiveProgress: (count, total) {
          onReceiveProgress?.call(count, total);
          final double result = (total > 0) ? count / total : 0.1;
          onReceiveProgressPercent?.call(result);
        },
        queryParameters: query,
        options: Options(headers: headers),
      );
      final DateTime end = DateTime.now();
      _logResponse(path, "DOWNLOAD", response: response, time: end.difference(start).inMilliseconds.toString());
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<ClientResponse<T>> get<T>(String path, {Map<String, dynamic>? query, Map<String, dynamic>? headers}) async {
    try {
      _logInfo(path, "GET", queryParamters: query, headers: headers, baseOptions: _dio.options.headers);
      final DateTime start = DateTime.now();
      final response = await _dio.get(
        path,
        queryParameters: query,
        options: Options(headers: headers),
      );
      final DateTime end = DateTime.now();
      _logResponse(path, "GET", response: response, time: end.difference(start).inMilliseconds.toString());
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<ClientResponse<T>> patch<T>(String path, {data, Map<String, dynamic>? query, Map<String, dynamic>? headers}) async {
    try {
      _logInfo(path, "PATCH", queryParamters: query, headers: headers, baseOptions: _dio.options.headers, data: data);
      final DateTime start = DateTime.now();
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: query,
        options: Options(headers: headers),
      );
      final DateTime end = DateTime.now();
      _logResponse(path, "PATCH", response: response, time: end.difference(start).inMilliseconds.toString());
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<ClientResponse<T>> post<T>(String path, {data, Map<String, dynamic>? query, Map<String, dynamic>? headers}) async {
    try {
      _logInfo(path, "POST", queryParamters: query, headers: headers, baseOptions: _dio.options.headers, data: jsonEncode(data));
      final DateTime start = DateTime.now();
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: query,
        options: Options(headers: headers),
      );
      final DateTime end = DateTime.now();
      _logResponse(path, "POST", response: response, time: end.difference(start).inMilliseconds.toString());
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<ClientResponse<T>> put<T>(String path, {data, Map<String, dynamic>? query, Map<String, dynamic>? headers}) async {
    try {
      _logInfo(path, "PUT", queryParamters: query, headers: headers, baseOptions: _dio.options.headers, data: data);
      final DateTime start = DateTime.now();
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: query,
        options: Options(headers: headers),
      );
      final DateTime end = DateTime.now();
      _logResponse(path, "PUT", response: response, time: end.difference(start).inMilliseconds.toString());
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<ClientResponse<T>> request<T>(String path, {data, Map<String, dynamic>? query, Map<String, dynamic>? headers}) async {
    try {
      _logInfo(path, "REQUEST", queryParamters: query, headers: headers, baseOptions: _dio.options.headers, data: data);
      final DateTime start = DateTime.now();
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: query,
        options: Options(headers: headers),
      );
      final DateTime end = DateTime.now();
      _logResponse(path, "REQUEST", response: response, time: end.difference(start).inMilliseconds.toString());
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      return _trowRestClientException(e);
    }
  }

  Future<ClientResponse<T>> _dioResponseConverter<T>(Response<dynamic> response) async {
    return ClientResponse<T>(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
    );
  }

  String getErrorMessage(DioException dioError) {
    if (dioError.response != null && dioError.response?.data != null && dioError.response?.data is Map) {
      if (dioError.response?.data['error_description'] != null) {
        return dioError.response?.data['error_description'];
      }
      if (dioError.response?.data['error'] != null) {
        return dioError.response?.data['error'];
      }
      if (dioError.response?.data['message'] != null) {
        return dioError.response?.data['message'];
      }
      if (dioError.response?.data['message'] != null) {
        return dioError.response?.data['message'];
      }

      if (dioError.response?.data['msg'] != null) {
        return dioError.response?.data['msg'];
      }
    }

    return dioError.toString();
  }

  Never _trowRestClientException(DioException dioError) {
    _logError(
        error: dioError.error.toString(),
        stackTrace: dioError.stackTrace,
        message: dioError.response?.data.toString() ?? dioError.message,
        statusCode: dioError.response?.statusCode.toString());
    throw Exception(dioError.response ?? dioError);
  }

  void _logInfo(String path, String methodo,
      {Map<String, dynamic>? headers, Map<String, dynamic>? baseOptions, Map<String, dynamic>? queryParamters, dynamic data}) {
    if (enableLogs == false) return;
    _logger.i(
        'METHOD: $methodo \nPATH: ${_dio.options.baseUrl}$path \nQUERYPARAMTERS: $queryParamters \nHEADERS: $headers \nBASEOPTIONS: $baseOptions \nDATA: ${data is Uint8List ? 'bytes' : data}');
  }

  void _logError({String? error, String? message, String? statusCode, StackTrace? stackTrace}) {
    if (enableLogs == false) return;
    _logger.e('ERROR: $error \nMESSAGE: $message \nSTATUSCODE: $statusCode');
  }

  void _logResponse(String path, String methodo, {Response? response, String? time}) {
    if (enableLogs == false) return;
    if (response?.statusCode == 200) {
      _logger.i(
          '[RESPONSE]: ${response?.statusCode}\nMETHOD: $methodo \nPATH: ${_dio.options.baseUrl}$path \nTIME: 🕑$time ms \nRESPONSE: ${response?.data}');
    } else {
      _logger.d(
          '[RESPONSE]: ${response?.statusCode}\nMETHOD: $methodo \nPATH: ${_dio.options.baseUrl}$path \nTIME: 🕑$time ms \nRESPONSE: ${response?.data}');
    }
  }
}
