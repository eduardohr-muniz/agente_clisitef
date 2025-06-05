/// Modelo que representa a resposta de uma requisição HTTP.
class ClientResponse<T> {
  /// Dados retornados pela requisição.
  T? data;

  /// Código de status HTTP.
  int? statusCode;

  /// Mensagem de status HTTP.
  String? statusMessage;

  /// Cria uma instância de resposta HTTP.
  ClientResponse({
    this.data,
    this.statusCode,
    this.statusMessage,
  });

  @override
  String toString() => 'HttpResponse(data: $data, statusCode: $statusCode, statusMessage: $statusMessage)';
}
