import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/const.dart';
import 'package:intl/intl.dart';

class AddTransaction extends StatefulWidget {
  AddTransaction({
    Key key,
    @required this.transactionType,
  }) : super(key: key);

  final String transactionType;
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  double deviceHeight;
  double deviceWidth;

  String dateTime;
  String date;

  // bool _paymentTypeSelected = false;

  String _selectedPaymentType;
  Future<Null> selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        Duration(days: 30),
      ),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dateTime = DateFormat.yMMMMd().format(pickedDate).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.fromLTRB(20, 20, 0.0, 0.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: lightGreen.withRed(210),
                    ),
                    height: 35.0,
                    width: 35.0,
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: primaryColor,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    HeaderWidget(
                      headerText: 'Add ${widget.transactionType}',
                      maxFontSize: 25,
                      minFontSize: 25,
                      textColor: Colors.black,
                    ),
                    Container(
                      height: 140.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                              'assets/images/addTransactionImage.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                HeaderWidget(
                  headerText: 'Amount',
                  maxFontSize: 18.0,
                  minFontSize: 16.0,
                  textColor: Colors.black,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15.0, right: 15.0),
                  padding: EdgeInsets.all(15.0),
                  width: deviceWidth,
                  height: deviceHeight * 0.10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Color(0xffecf8f8).withRed(210),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: deviceWidth * 0.75,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Text(
                        '₹',
                        style: GoogleFonts.roboto(
                            color: Colors.black45,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.0),
                HeaderWidget(
                  headerText: 'Category',
                  maxFontSize: 18.0,
                  minFontSize: 16,
                  textColor: Colors.black,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15.0, right: 15.0),
                  padding: EdgeInsets.all(15.0),
                  width: deviceWidth,
                  height: deviceHeight * 0.10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Color(0xffecf8f8).withRed(210),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: deviceWidth * 0.75,
                        child: TextFormField(
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.view_list,
                        color: Colors.black45,
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.0),
                HeaderWidget(
                  headerText: 'Date',
                  maxFontSize: 18.0,
                  minFontSize: 16.0,
                  textColor: Colors.black,
                ),
                SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    selectDate(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15.0, right: 15.0),
                    padding: EdgeInsets.all(15.0),
                    width: deviceWidth,
                    height: deviceHeight * 0.10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color(0xffecf8f8).withRed(210),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: deviceWidth * 0.70,
                          child: Text(
                            dateTime ?? '',
                          ),
                        ),
                        Icon(
                          Icons.date_range,
                          color: Colors.black45,
                          size: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                HeaderWidget(
                  headerText: 'Mode Of Payment',
                  maxFontSize: 18.0,
                  minFontSize: 16,
                  textColor: Colors.black,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15.0, right: 15.0),
                  padding: EdgeInsets.all(15.0),
                  width: deviceWidth,
                  height: deviceHeight * 0.10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Color(0xffecf8f8).withRed(210),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: deviceWidth * 0.7,
                        child: DropdownButton(
                          iconSize: 0.0,
                          underline: Container(),
                          value: _selectedPaymentType,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentType = value;
                            });
                          },
                          items: paymentList.map((months) {
                            return DropdownMenuItem(
                              child: Text(months),
                              value: months,
                            );
                          }).toList(),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                        size: 30.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                HeaderWidget(
                  headerText: 'Comment',
                  maxFontSize: 18.0,
                  minFontSize: 16.0,
                  textColor: Colors.black,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15.0, right: 15.0),
                  padding: EdgeInsets.all(15.0),
                  width: deviceWidth,
                  height: deviceHeight * 0.10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Color(0xffecf8f8).withRed(210),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: deviceWidth * 0.75,
                        child: TextFormField(
                          maxLength: 40,
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.only(
                                bottom: 2.0, left: 0.0, top: 0.0, right: 0.0),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.comment,
                        color: Colors.black45,
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15.0, right: 15.0),
                    padding: EdgeInsets.all(15.0),
                    width: deviceWidth,
                    height: deviceHeight * 0.09,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: buttonColor.withOpacity(0.5),
                          blurRadius: 6.0,
                          offset: Offset(2, 6),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20.0),
                      color: buttonColor,
                    ),
                    child: Center(
                      child: HeaderWidget(
                        headerText: '+ Save ${widget.transactionType}',
                        maxFontSize: 18.0,
                        minFontSize: 18.0,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
