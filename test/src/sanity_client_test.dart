import 'dart:convert';

import 'package:flutter_sanity/src/exception.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:flutter_sanity/src/sanity_client.dart';

void main() {
  late SanityClient client;

  group('SanityClient', () {
    test('constructor', () {
      client = SanityClient(
        projectId: 'test',
        dataset: 'test',
        token: 'test',
      );

      expect(client.dataset, 'test');
      expect(client.projectId, 'test');
      expect(client.token, 'test');
      expect(client.useCdn, true);
    });

    test('responds to 200', () async {
      final mockHttpClient = MockClient((request) async {
        return Response(json.encode({'result': 'test'}), 200);
      });

      client = SanityClient(
        projectId: 'test',
        dataset: 'test',
        client: mockHttpClient,
      );

      final response = await client.fetch('');

      expect(response, 'test');
    });

    test('responds to 400', () async {
      final mockHttpClient = MockClient((request) async {
        return Response('', 400);
      });

      client = SanityClient(
        projectId: 'test',
        dataset: 'test',
        client: mockHttpClient,
      );

      expect(() async => await client.fetch(''),
          throwsA(isA<BadRequestException>()));
    });

    test('responds to 401', () async {
      final mockHttpClient = MockClient((request) async {
        return Response('', 401);
      });

      client = SanityClient(
        projectId: 'test',
        dataset: 'test',
        client: mockHttpClient,
      );

      expect(() async => await client.fetch(''),
          throwsA(isA<UnauthorizedException>()));
    });

    test('responds to 403', () async {
      final mockHttpClient = MockClient((request) async {
        return Response('', 401);
      });

      client = SanityClient(
        projectId: 'test',
        dataset: 'test',
        client: mockHttpClient,
      );

      expect(() async => await client.fetch(''),
          throwsA(isA<UnauthorizedException>()));
    });

    test('responds to 500', () async {
      final mockHttpClient = MockClient((request) async {
        return Response('', 500);
      });

      client = SanityClient(
        projectId: 'test',
        dataset: 'test',
        client: mockHttpClient,
      );

      expect(() async => await client.fetch(''),
          throwsA(isA<FetchDataException>()));
    });

    test('builds uri correctly', () async {
      final paramParameter = {'test': 'test'};
      final queryParameter = {'query': 'test'};
      final projectId = 'test';
      final dataset = 'test';

      final mockHttpClient = MockClient((request) async {
        expect(request.url.scheme, 'https');
        expect(request.url.host, '$projectId.apicdn.sanity.io');
        expect(request.url.path, '/v1/data/query/$dataset');
        expect(request.url.queryParameters,
            {...queryParameter, ...paramParameter});

        return Response(json.encode({'result': 'test'}), 200);
      });

      client = SanityClient(
        projectId: projectId,
        dataset: dataset,
        client: mockHttpClient,
      );

      await client.fetch(
        'test',
        params: paramParameter,
      );
    });

    test('builds uri correctly', () async {
      final mockHttpClient = MockClient((request) async {
        return Response('', 200);
      });

      client = SanityClient(
        projectId: 'test',
        dataset: 'test',
        client: mockHttpClient,
      );

      expect(
          () async => await client.fetch(
                'test',
              ),
          throwsA(isA<FetchDataException>()));
    });
  });
}
