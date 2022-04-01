import 'dart:convert';

import 'package:flutter_sanity/src/exception.dart';
import 'package:flutter_sanity/src/http_client.dart';
import 'package:http/http.dart' as http;

class SanityClient {
  SanityClient({
    required this.projectId,
    required this.dataset,
    this.token,
    this.useCdn = true,
    http.BaseClient? client,
  }) {
    _client = client ?? HttpClient(token);
  }

  /// HttpClient used to make requests
  late final http.BaseClient _client;

  /// The project ID of the Sanity.io project.
  final String projectId;

  /// The dataset of the Sanity.io project.
  final String dataset;

  /// Use the Sanity CDN to fetch data.
  final bool useCdn;

  /// The bearer token of the project to use for authentication.
  /// If not set, the client will not send the token in the header.
  final String? token;

  /// Builds a [Uri] for a sanity endpoint.
  Uri _buildUri(String query, {Map<String, dynamic>? params}) {
    final Map<String, dynamic> queryParameters = <String, dynamic>{
      'query': query,
      if (params != null) ...params,
    };
    return Uri(
      scheme: 'https',
      host: '$projectId.${useCdn ? 'apicdn' : 'api'}.sanity.io',
      path: '/v1/data/query/$dataset',
      queryParameters: queryParameters,
    );
  }

  /// Handles the response from the Sanity API.
  ///
  /// Throws a [BadRequestException], [UnauthorizedException], [FetchDataException]
  /// in case the request did not succeed
  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return _decodeReponse(response.body);
      case 400:
        throw BadRequestException(response.body);
      case 401:
      case 403:
        throw UnauthorizedException(response.body);
      case 500:
      default:
        throw FetchDataException(
          'Error occured while communication with server with status code: ${response.statusCode}',
        );
    }
  }

  /// Decodes the Sanity response
  ///
  /// Throws a [FetchDataException] in case decoding the response fails.
  dynamic _decodeReponse(String responseBody) {
    try {
      final responseJson = jsonDecode(responseBody);
      return responseJson['result'];
    } catch (exception) {
      throw FetchDataException('Error occured while decoding response');
    }
  }

  /// Fetches the query from the Sanity API.
  ///
  /// Throws a [SanityException] in case  request fails.
  Future<dynamic> fetch(String query, {Map<String, dynamic>? params}) async {
    final Uri uri = _buildUri(query, params: params);
    final http.Response response = await _client.get(uri);
    return _returnResponse(response);
  }
}
