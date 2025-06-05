import 'package:agente_clisitef/src/services/client/client_response.dart';

/// Interface que define os métodos de cliente HTTP.
/// Implementada por classes que realizam requisições HTTP.
abstract class IClient {
  /// Autentica o cliente.
  IClient auth();

  /// Remove autenticação do cliente.
  IClient unauth();

  /// Realiza uma requisição POST.
  Future<ClientResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  /// Realiza uma requisição GET.
  Future<ClientResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  /// Realiza uma requisição PUT.
  Future<ClientResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  /// Realiza uma requisição PATCH.
  Future<ClientResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  /// Realiza uma requisição DELETE.
  Future<ClientResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  /// Realiza uma requisição HTTP genérica.
  Future<ClientResponse<T>> request<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });
}
