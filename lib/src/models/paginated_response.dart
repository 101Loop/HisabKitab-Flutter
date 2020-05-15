class PaginatedResponse {
  final int count;
  final String next;
  final String previous;
  final totalAmount;
  final results;
  final String error;
  final int statusCode;

  PaginatedResponse({this.count, this.next, this.previous, this.results, this.error, this.totalAmount, this.statusCode});

  factory PaginatedResponse.fromJson(var json) {
    return PaginatedResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: json['results'],
      totalAmount: json['total_amount'],
    );
  }

  factory PaginatedResponse.withError(String error, {int statusCode = -1}) {
    return PaginatedResponse(error: error, statusCode: statusCode);
  }
}
