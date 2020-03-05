import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/utils/baked_icons/rupee_icon_icons.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/const.dart';
import 'package:intl/intl.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String dateTime;
  String date;
  double deviceHeight;
  double deviceWidth;

  bool _amountTypeCash = false;
  bool _amountTypeCard = false;
  bool _amountTypeCheque = false;
  bool _amountTypeAccountType = false;
  bool _transactionTypeEarnings = false;
  bool _transactionTypeSpendings = false;

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
        backgroundColor: profileBG,
        body: Container(
          margin: EdgeInsets.fromLTRB(10, 10, 0.0, 0.0),
          child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: <Widget>[
                          Container(
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
                          SizedBox(width: 20.0),
                          Text(
                            'Filter',
                            style: GoogleFonts.roboto(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: deviceWidth * 0.45,
                          minWidth: deviceWidth * 0.3,
                        ),
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _transactionTypeEarnings,
                          onChanged: (value) {
                            setState(() {
                              _transactionTypeEarnings = value;
                            });
                          },
                          activeColor: primaryColor,
                          title: HeaderWidget(
                              headerText: 'Earnings',
                              textColor: Colors.black54,
                              maxFontSize: 15,
                              minFontSize: 12),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: deviceWidth * 0.45,
                          minWidth: deviceWidth * 0.3,
                        ),
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _transactionTypeSpendings,
                          onChanged: (value) {
                            setState(() {
                              _transactionTypeSpendings = value;
                            });
                          },
                          activeColor: primaryColor,
                          title: HeaderWidget(
                              headerText: 'Spendings',
                              textColor: Colors.black54,
                              maxFontSize: 15,
                              minFontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      cursorColor: primaryColor,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.black45,
                        ),
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                        fillColor: Colors.white,
                        hintText: 'Search By Name',
                        alignLabelWithHint: true,
                        hintStyle: GoogleFonts.nunito(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      selectDate(context);
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        readOnly: true,
                        initialValue: dateTime ?? '',
                        cursorColor: primaryColor,
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.date_range,
                            color: Colors.black45,
                          ),
                          contentPadding:
                              EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          fillColor: Colors.white,
                          hintText: 'Search By Date',
                          alignLabelWithHint: true,
                          hintStyle: GoogleFonts.nunito(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  HeaderWidget(
                      headerText: 'Search by Range',
                      textColor: Colors.black26,
                      maxFontSize: 18,
                      minFontSize: 15),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: deviceWidth * 0.4,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 15.0, 0.0),
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          cursorColor: primaryColor,
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            fillColor: Colors.white,
                            hintText: 'Minimum',
                            alignLabelWithHint: true,
                            hintStyle: GoogleFonts.nunito(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            suffixIcon: Icon(
                              RupeeIcon.rupee_icon,
                              size: 16.0,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: deviceWidth * 0.4,
                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          cursorColor: primaryColor,
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            fillColor: Colors.white,
                            hintText: 'Maximum',
                            alignLabelWithHint: true,
                            hintStyle: GoogleFonts.nunito(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            suffixIcon: Icon(
                              RupeeIcon.rupee_icon,
                              size: 16.0,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: deviceWidth * 0.45,
                          minWidth: deviceWidth * 0.3,
                        ),
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _amountTypeCash,
                          onChanged: (value) {
                            setState(() {
                              _amountTypeCash = value;
                            });
                          },
                          activeColor: primaryColor,
                          title: HeaderWidget(
                              headerText: 'Cash',
                              textColor: Colors.black54,
                              maxFontSize: 16,
                              minFontSize: 13),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: deviceWidth * 0.45,
                          minWidth: deviceWidth * 0.3,
                        ),
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _amountTypeCard,
                          onChanged: (value) {
                            setState(() {
                              _amountTypeCard = value;
                            });
                          },
                          activeColor: primaryColor,
                          title: HeaderWidget(
                              headerText: 'Card',
                              textColor: Colors.black54,
                              maxFontSize: 16,
                              minFontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: deviceWidth * 0.45,
                          minWidth: deviceWidth * 0.3,
                        ),
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _amountTypeCheque,
                          onChanged: (value) {
                            setState(() {
                              _amountTypeCheque = value;
                            });
                          },
                          activeColor: primaryColor,
                          title: HeaderWidget(
                              headerText: 'Cheque',
                              textColor: Colors.black54,
                              maxFontSize: 16,
                              minFontSize: 13),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: deviceWidth * 0.45,
                          minWidth: deviceWidth * 0.3,
                        ),
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _amountTypeAccountType,
                          onChanged: (value) {
                            setState(() {
                              _amountTypeAccountType = value;
                            });
                          },
                          activeColor: primaryColor,
                          title: HeaderWidget(
                              headerText: 'Account Transfer',
                              textColor: Colors.black54,
                              maxFontSize: 16,
                              minFontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 15.0, right: 15.0),
                      padding: EdgeInsets.all(10.0),
                      width: deviceWidth * 0.8,
                      height: deviceHeight * 0.08,
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
                          headerText: 'Apply',
                          maxFontSize: 16.0,
                          minFontSize: 16.0,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
