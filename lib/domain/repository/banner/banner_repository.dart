import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/model/banner/banner_data.dart';

abstract class BannerRepository {
  Future<ResponseResult<List<BannerData>>> getBanners();
}
