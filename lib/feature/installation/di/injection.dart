import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

import 'injection.config.dart';

final sl = GetIt.instance;

@injectableInit
void init() {
  sl.registerLazySingleton(() => http.Client());
  $initGetIt(sl);
}