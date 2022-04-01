class SanityException implements Exception {
  SanityException([
    this._message,
    this._prefix,
  ]);

  final String? _message;
  final String? _prefix;

  @override
  String toString() {
    return '$_prefix$_message';
  }
}

class FetchDataException extends SanityException {
  FetchDataException([String? message])
      : super(message, 'Error During Communication: ');
}

class BadRequestException extends SanityException {
  BadRequestException([String? message]) : super(message, 'Invalid Request: ');
}

class UnauthorizedException extends SanityException {
  UnauthorizedException([String? message]) : super(message, 'Unauthorized: ');
}

class InvalidInputException extends SanityException {
  InvalidInputException([String? message]) : super(message, 'Invalid Input: ');
}

class FormatDataException extends SanityException {
  FormatDataException([String? message])
      : super(message, 'Error During Parsing: ');
}
