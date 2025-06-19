import 'package:base_structure/data/repositories/auth/auth_repository.dart';
import 'package:base_structure/data/repositories/auth/auth_repository_impl.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:base_structure/data/services/api/auth_api_client.dart';

/// Configure dependencies for remote data.
/// This dependency list uses repositories that connect to a remote server.
List<SingleChildWidget> get providers {
  return [
    Provider(create: (context) => AuthApiClient()),
    // Provider(create: (context) => ApiClient()),
    // Provider(create: (context) => SharedPreferencesService()),
    ChangeNotifierProvider(
      create: (context) =>
          AuthRepositoryImplementation(authApiClient: context.read())
              as AuthRepository,
    ),
  ];
}
