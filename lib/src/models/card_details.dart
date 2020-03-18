class CardDetails {
  final int id;
  final String nickname;
  final Bank bank;
  final String description;
  final String account;
  final String vendor;
  final int statementDate;
  final String limit;
  final int dueDateDuration;

  CardDetails({this.id, this.nickname, this.bank, this.description, this.account, this.vendor, this.statementDate, this.limit, this.dueDateDuration});

  factory CardDetails.fromJson(var json) {
    return CardDetails(
      id: json['id'],
      nickname: json['nickname'],
      bank: Bank.fromJson(json['bank']),
      description: json['description'],
      account: json['account'],
      vendor: json['vendor'],
      statementDate: json['statement_date'],
      limit: json['limit'],
      dueDateDuration: json['duedate_duration'],
    );
  }
}

class Bank {
  final String name;
  final String bankAliases;

  Bank({this.name, this.bankAliases});

  factory Bank.fromJson(var json) {
    return Bank(name: json['name'], bankAliases: json['bank_aliases']);
  }
}
