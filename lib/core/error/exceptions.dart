class ServerException implements Exception {
  final int statusCode;
  final String exception;

  ServerException(this.statusCode, this.exception);
}
