import 'package:dio/dio.dart';
import 'package:estudo/interceptors/web_interceptor.dart';
import '../globals.dart';

final Dio dio = Dio(BaseOptions(
  baseUrl: BASE_URL,
))..interceptors.add(AuthInterceptor());
