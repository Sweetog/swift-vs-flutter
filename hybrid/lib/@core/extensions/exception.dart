

class ExistingAccountException implements Exception {
  String cause;
  ExistingAccountException(this.cause);
}