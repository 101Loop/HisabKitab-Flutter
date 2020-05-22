/// Model class for [PaginatedResponse]
///
/// Represents a common for every paginated response.
class PaginatedResponse {
  /// The length of the total items
  final int count;

  /// API URL for the next page
  final String next;

  /// API URL for the previous page
  final String previous;

  /// Total amount of the transaction, *for transaction API only
  final totalAmount;

  /// List of the paginated items
  final results;

  /// Error, encountered while fetching the data from the server
  final String error;

  /// Status code of the response while fetching the data from the server
  final int statusCode;

  /// Constructor.
  PaginatedResponse({this.count, this.next, this.previous, this.results, this.error, this.totalAmount, this.statusCode});

  /// Returns [PaginatedResponse] object from [json].
  factory PaginatedResponse.fromJson(var json) {
    return PaginatedResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: json['results'],
      totalAmount: json['total_amount'],
    );
  }

  /// Returns [PaginatedResponse] object with an [error].
  factory PaginatedResponse.withError(String error, {int statusCode = -1}) {
    return PaginatedResponse(error: error, statusCode: statusCode);
  }
}
