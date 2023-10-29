class ServerException implements Exception {
  ServerException({
    int? code = -1,
    String? message,
    this.data,
  }) {
    this.code = code ?? -1;
    this.message = message ?? 'Server Exception';
  }

  late final int code;
  late final String message;
  final dynamic data;

  @override
  String toString() => '[$code] $message | Data: $data';
}
