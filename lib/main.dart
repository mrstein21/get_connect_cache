import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'mixins/config/flavor_config.dart';
import 'mixins/constant/constant.dart';
import 'movie_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  FlavorConfig(
    flavor: Flavor.production,
    apiKey: 'b42f1d2342c381ec25f6180c52e51c00',
    baseUrl: 'https://api.themoviedb.org/3',
    appName: '$kAppName',
  );
  runApp(MovieApp());// Add this

}



