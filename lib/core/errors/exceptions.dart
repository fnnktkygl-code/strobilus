/// Custom exceptions for the data layer.
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException(this.message, {this.statusCode});

  @override
  String toString() => 'ServerException($statusCode: $message)';
}

class CacheException implements Exception {
  final String message;

  const CacheException(this.message);

  @override
  String toString() => 'CacheException($message)';
}

class MissingApiKeyException implements Exception {
  const MissingApiKeyException();

  @override
  String toString() => 'MissingApiKeyException: Gemini API key not found.';
}

class RateLimitException implements Exception {
  final String message;

  const RateLimitException(this.message);

  @override
  String toString() => 'RateLimitException($message)';
}
