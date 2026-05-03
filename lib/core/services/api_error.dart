class ApiError {
  final String message;
  final int? statusCode;

  ApiError({required this.message, this.statusCode});

  @override
  String toString() => 'ApiError(message: $message, statusCode: $statusCode)';
}
