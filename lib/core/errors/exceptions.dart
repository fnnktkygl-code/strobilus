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

class AiNetworkException implements Exception {
  final String message;
  const AiNetworkException([this.message = 'Network error during AI identification.']);
  @override
  String toString() => 'AiNetworkException: $message';
}

class AiQuotaException implements Exception {
  final String message;
  const AiQuotaException([this.message = 'AI quota exceeded.']);
  @override
  String toString() => 'AiQuotaException: $message';
}

class AiInvalidImageException implements Exception {
  final String message;
  const AiInvalidImageException([this.message = 'Invalid image provided to AI.']);
  @override
  String toString() => 'AiInvalidImageException: $message';
}

class AiGenericException implements Exception {
  final String message;
  const AiGenericException([this.message = 'An unknown AI error occurred.']);
  @override
  String toString() => 'AiGenericException: $message';
}
