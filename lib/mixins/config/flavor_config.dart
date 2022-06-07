import 'package:flutter/material.dart';

import '../constant/constant.dart';
enum Flavor { dev,uat ,production }

class FlavorConfig {
  final Flavor flavor;
  final String baseUrl;
  final String apiKey;
  final String appName;
  static FlavorConfig? _instance;

  factory FlavorConfig({
    @required flavor,
    @required apiKey,
    @required baseUrl,
    appName = kAppName,
  }) {
    _instance ??= FlavorConfig._initialize(flavor, baseUrl,apiKey ,appName);
    return _instance!;
  }

  FlavorConfig._initialize(this.flavor, this.baseUrl,this.apiKey ,this.appName);

  static FlavorConfig get instance {
    return _instance!;
  }

  static bool isProduction() => _instance!.flavor == Flavor.production;

  static bool isUAT() => _instance!.flavor == Flavor.uat;

  static bool isDevelopment() => _instance!.flavor == Flavor.dev;
}
