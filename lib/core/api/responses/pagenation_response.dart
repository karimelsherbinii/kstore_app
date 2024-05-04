import 'package:kstore/core/api/responses/meta.dart';

class PagenatoinResponse<Type> {
  final int page;
  final int perPage;
  final int total;
  final int totalPages;
  final List<Type> data;
  final List<Meta> meta;
  final int currentPage;

  PagenatoinResponse(
      {required this.page,
      required this.perPage,
      required this.total,
      required this.totalPages,
      required this.data,
      required this.meta,
      required this.currentPage});

  factory PagenatoinResponse.fromJson(Map<String, dynamic> json) {
    return PagenatoinResponse(
        page: json['page'],
        perPage: json['per_page'],
        total: json['total'],
        totalPages: json['total_pages'],
        data: json['data'],
        meta: json['meta'],
        currentPage: json['current_page']);
  }
}
