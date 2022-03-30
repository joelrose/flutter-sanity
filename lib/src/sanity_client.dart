import 'dart:convert';

import 'package:flutter_sanity/src/exception.dart';
import 'package:flutter_sanity/src/http_client.dart';
import 'package:http/http.dart' as http;

class SanityClient {
  SanityClient({
    required this.projectId,
    required this.dataset,
    this.useCdn = true,
  });

  final HttpClient _client = HttpClient();
  final String projectId;
  final String dataset;
  final bool useCdn;

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
        final responseJson = jsonDecode(response.body);
        return responseJson['result'];
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

  Future<dynamic> fetch(String query, {Map<String, dynamic>? params}) async {
    final Uri uri = _buildUri(query, params: params);
    final http.Response response = await _client.get(uri);
    return _returnResponse(response);
  }
}
