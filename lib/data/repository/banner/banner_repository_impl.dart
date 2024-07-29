import 'package:frontend/apis/banner_api.dart';
import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/model/banner/banner_data.dart';
import 'package:frontend/domain/repository/banner/banner_repository.dart';

class BannerRepositoryImpl extends BannerRepository {
  final BannerApi bannerApi;

  BannerRepositoryImpl({
    required this.bannerApi,
  });

  @override
  Future<ResponseResult<List<BannerData>>> getBanners() async {
    return await bannerApi.getBanners();
  }
}
