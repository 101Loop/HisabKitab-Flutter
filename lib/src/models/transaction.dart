class TransactionDetails {
  final int id;
  final Mode mode;
  final Contact contact;
  final String transactionDate;
  final String createDate;
  final String updateDate;
  final String category;
  final amount;
  final String comments;
  final int createdBy;

  TransactionDetails({this.id, this.mode, this.contact, this.transactionDate, this.createDate, this.updateDate, this.category, this.amount, this.comments, this.createdBy});

  factory TransactionDetails.fromJson(var json) {
    return TransactionDetails(
      id: json['id'],
      mode: Mode.fromJson(json['mode']),
      contact: Contact.fromJson(json['contact']),
      transactionDate: json['transaction_date'],
      createDate: json['create_date'],
      updateDate: json['update_date'],
      category: json['category'],
      amount: json['amount'],
      comments: json['comments'],
      createdBy: json['created_by'],
    );
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
