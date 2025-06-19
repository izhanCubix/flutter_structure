import 'request_type.dart';

class ApiRoute {
  final String route;
  final bool accessTokenRequired;
  final RequestType type;

  const ApiRoute({
    required this.route,
    required this.accessTokenRequired,
    required this.type,
  });
}
