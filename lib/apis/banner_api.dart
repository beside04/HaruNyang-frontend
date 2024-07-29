import 'package:dio/dio.dart';
import 'package:frontend/apis/response_result.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/domain/model/banner/banner_data.dart';

class BannerApi {
  String get _baseUrl => usingServer;

  final Dio dio;

  BannerApi({
    required this.dio,
  });

  Future<ResponseResult<List<BannerData>>> getBanners() async {
    try {
      String bannerUrl = '$_baseUrl/v2/banners/activated';
      Response response;
      response = await dio.get(
        bannerUrl,
      );

      final Iterable bannerList = response.data;
      final List<BannerData> bannerDataList = bannerList.map((e) => BannerData.fromJson(e)).toList();

      return ResponseResult.success(bannerDataList);
    } catch (e) {
      return ResponseResult.error(e.toString());
    }
  }
}
