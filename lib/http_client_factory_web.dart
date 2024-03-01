import 'package:fetch_client/fetch_client.dart';
import 'package:http/http.dart';
import 'package:http/browser_client.dart';

//Client httpClient() => FetchClient();
Client httpClient() => BrowserClient();