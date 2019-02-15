class Transaction {
  String _name, description, _transMode, _transType;
  var _date, _amount;

  Transaction(this._name, this._amount, this._transMode, this._transType, {this.description});

  get amount => _amount;

  get date => _date;

  get transType => _transType;

  get transMode => _transMode;

  String get name => _name;


}

var transactionList = <Transaction> [
new Transaction("Payment", 30000, "CASH", "CR", description: "Added Salary"),
new Transaction("Food", 2000, "CREDIT", "DB", description: "Food"),
new Transaction("Household", 1000, "CASH", "DB", description: "Household Expense"),
new Transaction("Phone Recharge", 448, "DEBIT", "DB", description: "Phone Recharge"),
new Transaction("TV Recharge", 200, "DEBIT", "DB", description: "TV Recharge"),
new Transaction("New TV", 15000, "CREDIT", "DB", description: "New TV"),
new Transaction("Payment", 30000, "CASH", "CR", description: "Added Salary"),
new Transaction("Food", 2000, "CREDIT", "DB", description: "Food"),
new Transaction("Household", 1000, "CASH", "DB", description: "Household Expense"),
new Transaction("Phone Recharge", 448, "DEBIT", "DB", description: "Phone Recharge"),
new Transaction("TV Recharge", 200, "DEBIT", "DB", description: "TV Recharge"),
new Transaction("New TV", 15000, "CREDIT", "DB", description: "New TV"),];