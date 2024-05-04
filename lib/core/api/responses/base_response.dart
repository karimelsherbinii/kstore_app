class BaseResponse<Type> {
  int? statusCode;
  String? message;
  Type? data;
  int? currentPage;
  int? lastPage;
  int? unReadTotal;
  int? total;
  Type? meta;
  String? token;

  BaseResponse({
    this.statusCode,
    this.message,
    this.data,
    this.currentPage,
    this.lastPage,
    this.unReadTotal,
    this.total,
    this.meta,
    this.token,
  });
}
