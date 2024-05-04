import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/category.dart';
import '../repositories/categories_repository.dart';

class GetCategories extends UseCase<BaseResponse, CategoriesParams> {
  final CategoriesRepository repository;

  GetCategories(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(CategoriesParams params) async =>
      await repository.getCategories(pageNo: params.pageNo);
}

class CategoriesParams extends Equatable {
  final int pageNo;

  const CategoriesParams({required this.pageNo});

  @override
  List<Object?> get props => [pageNo];
}
