import 'package:dartz/dartz.dart';

import '../../../../core/api/responses/base_response.dart';
import '../../../../core/error/failures.dart';

abstract class CategoriesRepository {
  Future<Either<Failure, BaseResponse>> getCategories({required int pageNo});
}
