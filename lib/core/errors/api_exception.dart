class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final int? tmdbStatusCode;

  const ApiException({
    required this.message,
    this.statusCode,
    this.tmdbStatusCode,
  });

  @override
  String toString() => message;

  bool get isUnauthorized => statusCode == 401 || tmdbStatusCode == 7;
  bool get isNotFound => statusCode == 404 || tmdbStatusCode == 34;
  bool get isRateLimited => statusCode == 429;
}
