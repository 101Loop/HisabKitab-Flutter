/// Model class for [TransactionDetails].
///
/// Represents the transaction
class TransactionDetails {
  /// Unique identification of the transaction
  final int id;

  /// Mode of payment
  final mode;

  /// Contact details of the transaction
  final contact;

  /// Transaction's respective dates
  final String transactionDate;
  final String createDate;
  final String updateDate;

  /// Kind of transaction, either credit or debit
  final String category;

  /// Amount of transaction
  final amount;

  /// Comments on transaction
  final String comments;

  /// Status or message of the response, either added, updated or an error
  final String message;

  /// Status code of the response, while fetching the data from the server
  final int statusCode;

  /// Constructor
  TransactionDetails({
    this.id,
    this.mode,
    this.contact,
    this.transactionDate,
    this.createDate,
    this.updateDate,
    this.category,
    this.amount,
    this.comments,
    this.message,
    this.statusCode,
  });

  /// Returns [TransactionDetails] object from [json].
  factory TransactionDetails.fromJson(var json, {String message}) {
    var mode = json['mode'];
    var contact = json['contact'];

    if (mode is! int) {
      mode = Mode.fromJson(json['mode']);
    }
    if (contact is! String) {
      contact = Contact.fromJson(json['contact']);
    }

    return TransactionDetails(
      id: json['id'],
      mode: mode,
      contact: contact,
      transactionDate: json['transaction_date'],
      createDate: json['create_date'],
      updateDate: json['update_date'],
      category: json['category'],
      amount: json['amount'],
      comments: json['comments'],
      message: message,
      statusCode: 200,
    );
  }

  /// Returns [TransactionDetails] object with an [error].
  factory TransactionDetails.withError(String error, {int statusCode = -1}) {
    return TransactionDetails(message: error, statusCode: statusCode);
  }

  /// Returns a map representation of [TransactionDetails] object.
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['amount'] = amount;
    map['category'] = category;
    map['transaction_date'] = transactionDate;
    map['mode'] = mode;
    map['contact'] = contact;

    if (comments != null && comments.isNotEmpty) map['comments'] = comments;

    return map;
  }
}

/// Model class for [Mode].
///
/// Represents mode of payment
class Mode {
  final int id;
  final String mode;

  /// Constructor.
  Mode({this.id, this.mode});

  /// Returns [Mode] object from [json].
  factory Mode.fromJson(var json) {
    return Mode(id: json['id'], mode: json['mode']);
  }
}

/// Model class for [Contact].
///
/// Represents contact details of a transaction
class Contact {
  final int id;
  final String name;
  final String email;
  final String mobile;

  /// Constructor.
  Contact({this.id, this.name, this.email, this.mobile});

  /// Returns [Contact] object from [json].
  factory Contact.fromJson(var json) {
    return Contact(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
    );
  }
}
