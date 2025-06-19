import 'api_route.dart';
import 'request_type.dart';

class WebService {
  static const String api = '/api';
  static const String baseUrl = 'https://reqres.in';

  static const login = ApiRoute(
    route: "$api/login",
    accessTokenRequired: false,
    type: RequestType.post,
  );
}
