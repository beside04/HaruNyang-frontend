import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/apis/dio.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:retrofit/retrofit.dart';

part 'kakao_login_repository.g.dart';

String apiEndPoint = 'Env.apiURL';

final kakaoLoginRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  final repository = KakaoLoginRepository(dio, baseUrl: apiEndPoint);
  return repository;
});

@RestApi()
abstract class KakaoLoginRepository {
  factory KakaoLoginRepository(Dio dio, {String baseUrl}) = _KakaoLoginRepository;
}