import 'package:test/test.dart';
import 'package:flutter_sanity/src/exception.dart';

void main() {
  group('AppException', () {
    test('FetchDataException toString', () {
      expect(
        FetchDataException('fetch data').toString(),
        'Error During Communication: fetch data',
      );
    });
    test('BadRequestException toString', () {
      expect(
        BadRequestException('bad request').toString(),
        'Invalid Request: bad request',
      );
    });
    test('UnauthorizedException toString', () {
      expect(
        UnauthorizedException('unauthorized').toString(),
        'Unauthorized: unauthorized',
      );
    });
    test('InvalidInputException toString', () {
      expect(
        InvalidInputException('input').toString(),
        'Invalid Input: input',
      );
    });
    test('FormatDataException toString', () {
      expect(
        FormatDataException('format data').toString(),
        'Error During Parsing: format data',
      );
    });
  });
}
