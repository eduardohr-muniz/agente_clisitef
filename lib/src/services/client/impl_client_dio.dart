import 'package:agente_clisitef/src/services/client/clien_exports.dart';
import 'package:dio/dio.dart';
import 'package:sentry_dio/sentry_dio.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

class ClientDio implements IClient {
  late final Dio _dio;
  late Talker? talker;
  final bool enableLogs;

  ClientDio({BaseOptions? baseOptions, this.enableLogs = false, this.talker, int? clearLogInDays}) {
    _dio = Dio(baseOptions ?? _defaultOptions);
    if (talker != null) {
      _dio.interceptors.add(
        TalkerDioLogger(
          talker: talker!,
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printErrorHeaders: true,
            enabled: true,
          ),
        ),
      );
    }
    _dio.addSentry();
  }

  final _defaultOptions = BaseOptions(baseUrl: 'hhtps://localhost:8080');

  @override
  Future<ClientResponse<T>> delete<T>(String path, {data, Map<String, dynamic>? query, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: query,
        options: Options(headers: headers),
      );

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

      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<ClientResponse<T>> get<T>(String path, {Map<String, dynamic>? query, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: query,
        options: Options(headers: headers),
      );

      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<ClientResponse<T>> patch<T>(String path, {data, Map<String, dynamic>? query, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: query,
        options: Options(headers: headers),
      );

      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<ClientResponse<T>> post<T>(String path, {data, Map<String, dynamic>? query, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: query,
        options: Options(headers: headers),
      );

      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<ClientResponse<T>> put<T>(String path, {data, Map<String, dynamic>? query, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: query,
        options: Options(headers: headers),
      );

      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<ClientResponse<T>> request<T>(String path, {data, Map<String, dynamic>? query, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: query,
        options: Options(headers: headers),
      );

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
    throw dioError;
  }
}
