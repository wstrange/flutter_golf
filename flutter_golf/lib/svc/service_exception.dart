class ServiceException implements Exception {
  final String _message;

  ServiceException(this._message);
  @override
  toString() => "Service Exception $_message";
}
