class Meta {
  final int total;
  final int? count;
  final int perPage;
  final int currentPage;
  final int? totalPages;
  final int from;
  final int to;
  final int lastPage;

  Meta({
    required this.total,
    required this.count,
    required this.perPage,
    required this.currentPage,
    required this.totalPages,
    required this.from,
    required this.to,
    required this.lastPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'],
      count: json['count'],
      perPage: json['per_page'],
      currentPage: json['current_page'],
      totalPages: json['total_pages'],
      from: json['from'],
      to: json['to'],
      lastPage: json['last_page'],
    );
  }
}
