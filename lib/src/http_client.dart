import 'package:http/http.dart' as http;

class HttpClient extends http.BaseClient {
  factory HttpClient() {
    final http.Client client = http.Client();
    return HttpClient._createInstance(client);
  }

  HttpClient._createInstance(this._inner);

  final http.Client _inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _inner.send(request);
  }
}
