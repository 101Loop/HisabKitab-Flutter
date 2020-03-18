class PaginatedResponse {
  final int count;
  final String next;
  final String previous;
  final totalAmount;
  final results;
  final String error;

  PaginatedResponse({this.count, this.next, this.previous, this.results, this.error, this.totalAmount});

  factory PaginatedResponse.fromJson(var json) {
    return PaginatedResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: json['results'],
      totalAmount: json['total_amount'],
    );
  }

  factory PaginatedResponse.withError(String error) {
    return PaginatedResponse(error: error);
  }
}
