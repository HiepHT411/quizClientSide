class AuthenticationResult {
  final bool success;
  final String errorMessage;

  AuthenticationResult({
    required this.success,
    this.errorMessage = '',
  });
}