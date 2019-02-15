import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hisab_kitab/ui/fab_reveal.dart';
import 'package:hisab_kitab/models/transaction.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Hisab Kitab'),
        actions: <Widget>[
          new Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.calendar_today),
          )
        ],
      ),
      floatingActionButton: _createFab(),
      body: ListView.builder(
        itemCount: transactionList.length,
        itemBuilder: (BuildContext context, int index) {
          Transaction transaction = transactionList[index];
          
          if(transaction.transType == "CR") {
             return _createTransaction(transaction, Colors.green);
          } else {
            return _createTransaction(transaction, Colors.red);
          }
        },
      ),
      bottomNavigationBar: _createBottomNavBar(),
    );
  }

  Widget _createFab() {
    return FabWithIcons(
      icons: [Icons.attach_money, Icons.money_off],
      onIconTapped: (int index) {
        switch (index) {
          case 0:
            Navigator.of(context).pushNamed('/Credit');
            break;
          case 1:
            Navigator.of(context).pushNamed('/Debit');
            break;
        }
      },
    );
  }
  
  Widget _createTransaction(Transaction transaction, Color color) {
    return ListTile(
      title: Text(transaction.name),
      subtitle: Text(transaction.transMode, style: TextStyle(fontSize: 12.0),),
      leading: CircleAvatar(child: Text(transaction.transType), backgroundColor: color,),
      trailing: Text(NumberFormat.currency(locale: Intl.getCurrentLocale(), name: "₹").format(transaction.amount),
        style: TextStyle(color: color, ),),
    );
  }

  Widget _createBottomNavBar() {
    return new Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListTile(
              title: Text('Credit'),
              subtitle: Text(
                NumberFormat.currency(locale: Intl.getCurrentLocale(), name: "₹").format(_calculateCredit()),
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text('Expense'),
              subtitle: Text(
                NumberFormat.currency(locale: Intl.getCurrentLocale(), name: "₹").format(_calculateDebit()),
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.account_balance_wallet,
              color: Colors.indigoAccent,
            ),
          )
        ],
      ),
    );
  }

  int _calculateDebit() {
    int expense = 0;
    transactionList.forEach((transaction) {
      if(transaction.transType == "DB") expense += transaction.amount;
    });

    return expense;
  }

  int _calculateCredit() {
    int credit = 0;
    transactionList.forEach((transaction) {
      if(transaction.transType == "CR") credit += transaction.amount;
    });

    return credit;
  }
}
