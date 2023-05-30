class ApiCallException implements Exception {
  int httpStatus;
  String title;
  String message;

  ApiCallException({
    required this.httpStatus,
    required this.title,
    required this.message,
  });

  @override
  String toString() => 'ApiCallException: $httpStatus : $message';
}
