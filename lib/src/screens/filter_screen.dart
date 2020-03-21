import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/mixins/validator.dart';
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/src/screens/main_screen.dart';
import 'package:hisabkitab/utils/baked_icons/rupee_icon_icons.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/const.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> with ValidationMixin {
  String date;
  double deviceHeight;
  double deviceWidth;

  AppState provider;

  final _formKey = GlobalKey<FormState>();

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
      provider.setTempDateQuery(DateFormat('yyyy-MM-dd').format(pickedDate).toString(), willNotify: false);
      provider.setDateTime(DateFormat('yyyy-MM-dd').format(pickedDate).toString());
    }
  }

  @override
  void initState() {
    super.initState();

    AppState initStateProvider = Provider.of<AppState>(context, listen: false);

    initStateProvider.setTempEarning(initStateProvider.isEarning, willNotify: false);
    initStateProvider.setTempSpending(initStateProvider.isSpending, willNotify: false);
    initStateProvider.setTempSearchQuery(initStateProvider.searchQuery, willNotify: false);
    initStateProvider.setTempDateQuery(initStateProvider.dateQuery, willNotify: false);
    initStateProvider.setTempMinAmountQuery(initStateProvider.minAmountQuery, willNotify: false);
    initStateProvider.setTempMaxAmountQuery(initStateProvider.maxAmountQuery, willNotify: false);
    initStateProvider.setTempCashQuery(initStateProvider.isCashQuery, willNotify: false);
    initStateProvider.setTempCardQuery(initStateProvider.isCardQuery, willNotify: false);
    initStateProvider.setTempChequeQuery(initStateProvider.isChequeQuery, willNotify: false);
    initStateProvider.setTempAccountQuery(initStateProvider.isAccountQuery, willNotify: false);
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    provider = Provider.of<AppState>(context);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: profileBG,
          body: Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0.0, 0.0),
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
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
                                      _goToMainScreen();
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
                              value: provider.isTempEarning,
                              onChanged: (value) {
                                provider.setTempEarning(value);
                              },
                              activeColor: primaryColor,
                              title: HeaderWidget(headerText: 'Earnings', textColor: Colors.black54, maxFontSize: 15, minFontSize: 12),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: deviceWidth * 0.45,
                              minWidth: deviceWidth * 0.3,
                            ),
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: provider.isTempSpending,
                              onChanged: (value) {
                                provider.setTempSpending(value);
                              },
                              activeColor: primaryColor,
                              title: HeaderWidget(headerText: 'Spendings', textColor: Colors.black54, maxFontSize: 15, minFontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(15.0),
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: provider.searchQuery ?? '',
                          onSaved: (value) {
                            provider.setTempSearchQuery(value, willNotify: false);
                          },
                          cursorColor: primaryColor,
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.search,
                              color: Colors.black45,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
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
                          FocusScope.of(context).unfocus();
                          selectDate(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15.0),
                          width: deviceWidth * 0.87,
                          height: 50,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.grey)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: deviceWidth * 0.70,
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  provider.dateTime != null && provider.dateTime.isNotEmpty ? provider.dateTime : 'Search By Date',
                                  style: GoogleFonts.nunito(
                                    color: provider.dateTime != null && provider.dateTime.isNotEmpty ? Colors.black54 : Colors.grey.shade400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(
                                  Icons.date_range,
                                  color: Colors.black45,
                                  size: 20.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      HeaderWidget(headerText: 'Search by Range', textColor: Colors.black26, maxFontSize: 18, minFontSize: 15),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: deviceWidth * 0.4,
                            margin: EdgeInsets.fromLTRB(10.0, 0.0, 15.0, 0.0),
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              initialValue: provider.minAmountQuery != -1 ? provider.minAmountQuery.toString() : '',
                              validator: validateNullableDoubleValue,
                              onSaved: (value) {
                                if(value == null || value.isEmpty) return;
                                provider.setTempMinAmountQuery(double.parse(value));
                              },
                              cursorColor: primaryColor,
                              textAlign: TextAlign.left,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
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
                              initialValue: provider.maxAmountQuery != -1 ? provider.maxAmountQuery : '',
                              validator: validateNullableDoubleValue,
                              onSaved: (value) {
                                if(value == null || value.isEmpty) return;
                                provider.setMaxAmountQuery(double.parse(value));
                              },
                              cursorColor: primaryColor,
                              textAlign: TextAlign.left,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
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
                              value: provider.isTempCashQuery,
                              onChanged: (value) {
                                provider.setTempCashQuery(value);
                              },
                              activeColor: primaryColor,
                              title: HeaderWidget(headerText: 'Cash', textColor: Colors.black54, maxFontSize: 16, minFontSize: 13),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: deviceWidth * 0.45,
                              minWidth: deviceWidth * 0.3,
                            ),
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: provider.isTempCardQuery,
                              onChanged: (value) {
                                provider.setTempCardQuery(value);
                              },
                              activeColor: primaryColor,
                              title: HeaderWidget(headerText: 'Card', textColor: Colors.black54, maxFontSize: 16, minFontSize: 13),
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
                              value: provider.isTempChequeQuery,
                              onChanged: (value) {
                                provider.setTempChequeQuery(value);
                              },
                              activeColor: primaryColor,
                              title: HeaderWidget(headerText: 'Cheque', textColor: Colors.black54, maxFontSize: 16, minFontSize: 13),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: deviceWidth * 0.45,
                              minWidth: deviceWidth * 0.3,
                            ),
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: provider.isTempAccountQuery,
                              onChanged: (value) {
                                provider.setTempAccountQuery(value);
                              },
                              activeColor: primaryColor,
                              title: HeaderWidget(headerText: 'Account Transfer', textColor: Colors.black54, maxFontSize: 16, minFontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.0),
                      GestureDetector(
                        onTap: () {
                          _submit();
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
                  ),
                )),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    provider.setTempEarning(false, willNotify: false);
    provider.setTempSpending(false, willNotify: false);
    provider.setTempSearchQuery('', willNotify: false);
    provider.setTempDateQuery('', willNotify: false);
    provider.setTempMinAmountQuery(-1, willNotify: false);
    provider.setTempMaxAmountQuery(-1, willNotify: false);
    provider.setTempCashQuery(false, willNotify: false);
    provider.setTempCardQuery(false, willNotify: false);
    provider.setTempChequeQuery(false, willNotify: false);
    provider.setTempAccountQuery(false, willNotify: false);
  }

  void _submit() {
    final _formState = _formKey.currentState;

    if (_formState.validate()) {
      _formState.save();

      provider.setEarning(provider.isTempEarning, willNotify: false);
      provider.setSpending(provider.isTempSpending, willNotify: false);
      provider.setSearchQuery(provider.tempSearchQuery, willNotify: false);
      provider.setDateQuery(provider.tempDateQuery, willNotify: false);
      provider.setMinAmountQuery(provider.tempMinAmountQuery, willNotify: false);
      provider.setMaxAmountQuery(provider.tempMaxAmountQuery, willNotify: false);
      provider.setCashQuery(provider.isTempCashQuery, willNotify: false);
      provider.setCardQuery(provider.isTempCardQuery, willNotify: false);
      provider.setChequeQuery(provider.isTempChequeQuery, willNotify: false);
      provider.setAccountQuery(provider.isTempAccountQuery, willNotify: false);

      _goToMainScreen();
    }
  }

  Future<bool> _onBackPressed() async {
    _goToMainScreen();
    return false;
  }

  void _goToMainScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
  }
}
