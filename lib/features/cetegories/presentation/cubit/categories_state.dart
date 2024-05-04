import 'package:equatable/equatable.dart';

import '../../domain/entities/category.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class GetCategoriesLoading extends CategoriesState {
  final bool isFirstFetch;
  const GetCategoriesLoading({this.isFirstFetch = false});
  @override
  List<Object> get props => [isFirstFetch];
}

class GetCategoriesLoaded extends CategoriesState {
  final List<Category> categories;

  const GetCategoriesLoaded({required this.categories});
}

class GetCategoriesError extends CategoriesState {
  final String msg;

  const GetCategoriesError({required this.msg});
}
