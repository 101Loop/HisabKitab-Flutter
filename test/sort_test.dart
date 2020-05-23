import 'package:hisabkitab/src/models/transaction.dart';
import 'package:hisabkitab/src/screens/dashboard.dart';
import 'package:test/test.dart';

void main() {
  const int NAME_ASCENDING = 0;
  const int NAME_DESCENDING = 1;
  const int AMOUNT_HIGH_TO_LOW = 2;
  const int AMOUNT_LOW_TO_HIGH = 3;

  TransactionDetails transactionDetails1 = TransactionDetails(amount: 25000, contact: Contact(name: 'salary'));
  TransactionDetails transactionDetails2 = TransactionDetails(amount: 5000, contact: Contact(name: 'ration'));
  TransactionDetails transactionDetails3 = TransactionDetails(amount: 100, contact: Contact(name: 'feul'));
  TransactionDetails transactionDetails4 = TransactionDetails(amount: 1000, contact: Contact(name: 'groceries'));

  List<TransactionDetails> transactionList = [transactionDetails1, transactionDetails2, transactionDetails3, transactionDetails4];

  List<TransactionDetails> ascendingSorted = [transactionDetails3, transactionDetails4, transactionDetails2, transactionDetails1];
  List<TransactionDetails> descendingSorted = [transactionDetails1, transactionDetails2, transactionDetails4, transactionDetails3];
  List<TransactionDetails> highToLowSorted = [transactionDetails1, transactionDetails2, transactionDetails4, transactionDetails3];
  List<TransactionDetails> lowToHighSorted = [transactionDetails3, transactionDetails4, transactionDetails2, transactionDetails1];

  group('sorting test', () {
    test('ascending name test', () {
      List<TransactionDetails> result = DashboardState().sortList(transactionList, NAME_ASCENDING);
      expect(result, ascendingSorted);
    });

    test('descending name test', () {
      List<TransactionDetails> result = DashboardState().sortList(transactionList, NAME_DESCENDING);
      expect(result, descendingSorted);
    });

    test('high to low amount test', () {
      List<TransactionDetails> result = DashboardState().sortList(transactionList, AMOUNT_HIGH_TO_LOW);
      expect(result, highToLowSorted);
    });

    test('low to high amount test', () {
      List<TransactionDetails> result = DashboardState().sortList(transactionList, AMOUNT_LOW_TO_HIGH);
      expect(result, lowToHighSorted);
    });
  });
}