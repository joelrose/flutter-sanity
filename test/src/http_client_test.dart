import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:flutter_sanity/src/http_client.dart';

void main() {
  group('HttpClient', () {
    test('sets Authorization Header', () async {
      final client = HttpClient(
        'test',
        client: MockClient((request) async {
          expect(request.headers.containsKey('Authorization'), true);
          expect(request.headers['Authorization'], 'Bearer test');

          return Response('', 200);
        }),
      );

      await client.get(Uri(path: ''));
    });

    test('sets no Authorization Header', () async {
      final client = HttpClient(
        null,
        client: MockClient((request) async {
          expect(request.headers.containsKey('Authorization'), false);

          return Response('', 200);
        }),
      );

      await client.get(Uri(path: ''));
    });
  });
}
