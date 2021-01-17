import 'package:http/http.dart' as http;

class AppHttpClient{
  static final AppHttpClient _instance = AppHttpClient._internal();
  http.Client client;

  AppHttpClient._internal(){
    this.client = http.Client();
  }

  factory AppHttpClient() {
    return _instance;
  }
}