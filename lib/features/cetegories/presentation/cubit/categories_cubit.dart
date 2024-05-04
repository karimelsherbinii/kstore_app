import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:kstore/features/cetegories/domain/entities/category.dart';
import 'package:kstore/features/cetegories/domain/usecases/get_categories.dart';

import '../../../../core/api/responses/base_response.dart';
import '../../../../core/error/failures.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategories getCategoriesUseCase;
  CategoriesCubit({required this.getCategoriesUseCase})
      : super(CategoriesInitial());

  int pageNo = 1;
  int totalPage = 1;
  bool loadMore = false;

  List<Category> categories = [];
  Future<void> getCategories() async {
    if (state is GetCategoriesLoading) return;
    emit(GetCategoriesLoading(isFirstFetch: pageNo == 1));
    Either<Failure, BaseResponse> response =
        await getCategoriesUseCase(CategoriesParams(pageNo: pageNo));
    response.fold(
        (failure) => emit(GetCategoriesError(msg: failure.message.toString())),
        (response) {
      categories = response.data;
      //! Uncomment this to enable pagination
      // pageNo++;
      // totalPage = response.lastPage!;
      // log(categories[0].images[0].toString(), name: "Categories");

      emit(GetCategoriesLoaded(categories: response.data));
    });
  }

  clearData() {
    categories = [];
    pageNo = 1;
    totalPage = 1;
  }
}
