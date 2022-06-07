import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:movie_trial/mixins/config/flavor_config.dart';
import 'package:movie_trial/mixins/constant/constant.dart';
import 'package:movie_trial/mixins/network/error_handling.dart';
import 'package:movie_trial/mixins/network/interceptor.dart';
import 'package:movie_trial/model/detail_movie.dart';
import 'package:movie_trial/model/res/movie_res.dart';

import '../mixins/logging/logger.dart';

class MovieProvider extends GetConnect {

  @override
  void onInit() {
    super.onInit();
    allowAutoSignedCert = true;
    httpClient.baseUrl = "${FlavorConfig.instance.baseUrl}";
    httpClient.timeout = Duration(milliseconds: kConnectionTimeout);
    httpClient.addRequestModifier((request) {
      return requestInterceptor(request);
    });
    httpClient.addResponseModifier((request, response) {
      return responseInterceptor(request, response);
    });
  }

  Future<DetailMovie> geDetailMovie(String id) async {
    final response = await get(
      '/movie/$id',
      query: {
        'api_key':FlavorConfig.instance.apiKey
      },
    );
    try {
      return DetailMovie.fromJson(response.body);
    } catch (e, s) {
      logger.e('getDetailMovie', e, s);
      if(response.hasError){
        ///kalau responsenya error dan alamat api sudah terdaftar di GetStorage
        ///maka kita akan return JSONnya via GetStorage seperti dibawah ini
        if(GetStorage().hasData(response.request!.url.toString())){
          Map<String,dynamic> responseCache=GetStorage().read(response.request!.url.toString());
          return DetailMovie.fromJson(responseCache);
        }
        return Future.error(ErrorHandling(response));
      }else{
        return Future.error(ErrorHandling(e.toString()));
      }
    }
  }

  Future<MovieRes> getTopRatedMovie(int page) async {
    final response = await get(
      '/movie/top_rated',
      query: {
        'page':'$page',
        'api_key':FlavorConfig.instance.apiKey
      },
    );
    try {
      return MovieRes.fromJson(response.body);
    } catch (e, s) {
      logger.e('getMoviePopular', e, s);
      if(response.hasError){
        ///kalau responsenya error dan alamat api sudah terdaftar di GetStorage
        ///maka kita akan return JSONnya via GetStorage seperti dibawah ini
        if(GetStorage().hasData(response.request!.url.toString())){
          Map<String,dynamic> responseCache=GetStorage().read(response.request!.url.toString());
          return MovieRes.fromJson(responseCache);
        }
        return Future.error(ErrorHandling(response));
      }else{
        return Future.error(ErrorHandling(e.toString()));
      }
    }
  }



}