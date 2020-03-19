class TransactionDetails {
  final int id;
  final mode;
  final contact;
  final String transactionDate;
  final String createDate;
  final String updateDate;
  final String category;
  final amount;
  final String comments;
  final int createdBy;
  final String message;
  final int statusCode;

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
    this.createdBy,
    this.message,
    this.statusCode,
  });

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
      createdBy: json['created_by'],
      message: message,
      statusCode: 200,
    );
  }

  factory TransactionDetails.withError(String error) {
    return TransactionDetails(message: error);
  }

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

class Mode {
  final int id;
  final String mode;

  Mode({this.id, this.mode});

  factory Mode.fromJson(var json) {
    return Mode(id: json['id'], mode: json['mode']);
  }
}

class Contact {
  final int id;
  final String name;
  final String email;
  final String mobile;

  Contact({this.id, this.name, this.email, this.mobile});

  factory Contact.fromJson(var json) {
    return Contact(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
    );
  }
}
