import 'dart:convert';

import 'package:kstore/core/api/api_consumer.dart';
import 'package:kstore/core/api/end_points.dart';
import 'package:kstore/core/utils/app_strings.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/features/cetegories/data/models/category_model.dart';

import '../../../../core/api/responses/base_response.dart';

abstract class CategoriesRemoteDataSource {
  Future<BaseResponse> getCategories({required int pageNo});
}

class CategoryRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  ApiConsumer apiConsumer;
  CategoryRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<BaseResponse> getCategories({required int pageNo}) async {
    final response = await apiConsumer.get(
      EndPoints.categories,
      queryParameters: {
        AppStrings.pageSize: Constants.fetchLimit,
        AppStrings.pageNumber: pageNo,
      },
    );
    BaseResponse baseResponse = BaseResponse(statusCode: response.statusCode);
    final jsonResponse = jsonDecode(response.toString());
    Iterable iterable = jsonResponse[AppStrings.data];
    baseResponse.data =
        iterable.map((model) => CategoryModel.formJson(model)).toList();
    baseResponse.lastPage = jsonResponse[AppStrings.meta][AppStrings.lastPage];
    baseResponse.currentPage =
        jsonResponse[AppStrings.meta][AppStrings.currentPage];
    return baseResponse;
  }
}
