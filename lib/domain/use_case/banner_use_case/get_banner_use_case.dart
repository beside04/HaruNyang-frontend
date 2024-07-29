import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/model/banner/banner_data.dart';
import 'package:frontend/domain/repository/banner/banner_repository.dart';

class GetBannerUseCase {
  final BannerRepository bannerRepository;

  GetBannerUseCase({
    required this.bannerRepository,
  });

  Future<ResponseResult<List<BannerData>>> call() async {
    return await bannerRepository.getBanners();
  }
}
