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
  }) {
    _client = HttpClient(token);
  }

  late final HttpClient _client;

  final String projectId;

  final String dataset;

  final bool useCdn;

  final String? token;

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

  dynamic _decodeReponse(String responseBody) {
    try {
      final responseJson = jsonDecode(responseBody);
      return responseJson['result'];
    } catch (exception) {
      throw FetchDataException('Error occured while decoding response');
    }
  }

  Future<dynamic> fetch(String query, {Map<String, dynamic>? params}) async {
    final Uri uri = _buildUri(query, params: params);
    final http.Response response = await _client.get(uri);
    return _returnResponse(response);
  }
}
