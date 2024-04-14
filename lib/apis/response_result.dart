import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_result.freezed.dart';

@freezed
class ResponseResult<T> with _$ResponseResult<T> {
  const factory ResponseResult.success(T data) = Success;

  const factory ResponseResult.error(String message) = Error;
}
