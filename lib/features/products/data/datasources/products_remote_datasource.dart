import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:kstore/core/api/api_consumer.dart';
import 'package:kstore/core/api/end_points.dart';
import 'package:kstore/core/utils/app_strings.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/features/products/data/models/product_model.dart';

import '../../../../core/api/responses/base_response.dart';

abstract class ProductsRemoteDataSource {
  Future<BaseResponse> getProducts({
    required int pageNo,
    String? searchQuery,
    String? perPage,
    String? categoryId,
    String? sortBy,
    String? sortOrder,
  });
  Future<BaseResponse> getProductsByCategory(
      {required int categoryId, required int pageNo, String? searchQuery});
  Future<BaseResponse> getProductById({required int productId});
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  ApiConsumer apiConsumer;
  ProductsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<BaseResponse> getProducts({
    required int pageNo,
    String? searchQuery,
    String? perPage,
    String? categoryId,
    String? sortBy,
    String? sortOrder,
  }) async {
    Response response = await apiConsumer.get(
      EndPoints.products,
      queryParameters: {
        AppStrings.perPage: Constants.fetchLimit,
        AppStrings.pageNumber: pageNo,
        if (searchQuery != null) AppStrings.searchQuery: searchQuery,
        if (categoryId != null) AppStrings.categoryId: categoryId,
        if (sortBy != null) AppStrings.sortBy: sortBy,
        if (sortOrder != null) AppStrings.sortOrder: sortOrder,
      },
    );
    BaseResponse baseResponse = BaseResponse(statusCode: response.statusCode);
    final jsonResponse = jsonDecode(response.toString());
    Iterable iterable = jsonResponse[AppStrings.data];
    baseResponse.lastPage = jsonResponse[AppStrings.meta][AppStrings.lastPage];
    baseResponse.currentPage =
        jsonResponse[AppStrings.meta][AppStrings.currentPage];
    baseResponse.data =
        iterable.map((model) => ProductModel.fromJson(model)).toList();

    return baseResponse;
  }

  @override
  Future<BaseResponse> getProductsByCategory(
      {required int categoryId,
      required int pageNo,
      String? searchQuery}) async {
    final response = await apiConsumer.get(
      EndPoints.products,
      queryParameters: searchQuery != null
          ? {
              AppStrings.pageSize: Constants.fetchLimit,
              AppStrings.pageNumber: pageNo,
              AppStrings.categoryId: categoryId,
              AppStrings.searchQuery: searchQuery,
            }
          : {
              AppStrings.pageSize: 7,
              AppStrings.pageNumber: pageNo,
              AppStrings.categoryId: categoryId,
            },
    );
    BaseResponse baseResponse = BaseResponse();
    var jsonResponse = jsonDecode(response.toString());
    Iterable iterable = jsonResponse[AppStrings.data];
    baseResponse.data =
        iterable.map((model) => ProductModel.fromJson(model)).toList();
    baseResponse.lastPage = jsonResponse[AppStrings.meta][AppStrings.lastPage];
    baseResponse.currentPage =
        jsonResponse[AppStrings.meta][AppStrings.currentPage];
    return baseResponse;
  }

  @override
  Future<BaseResponse> getProductById({required int productId}) async {
    final response = await apiConsumer.get("${EndPoints.products}/$productId");
    BaseResponse baseResponse = BaseResponse();
    var jsonResponse = jsonDecode(response.toString());
    baseResponse.data = ProductModel.fromJson(jsonResponse);
    return baseResponse;
  }
}
