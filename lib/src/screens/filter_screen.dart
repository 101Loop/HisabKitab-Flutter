import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/mixins/validator.dart';
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/src/screens/main_screen.dart';
import 'package:hisabkitab/utils/baked_icons/rupee_icon_icons.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/const.dart' as Constants;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

TextEditingController searchController = TextEditingController();
TextEditingController minTextController = TextEditingController();
TextEditingController maxTextController = TextEditingController();

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
      provider.setTempDateQuery(
          DateFormat('yyyy-MM-dd').format(pickedDate).toString(),
          willNotify: false);
      provider.setTempDateTime(
          DateFormat('yyyy-MM-dd').format(pickedDate).toString());
    }
  }

  @override
  void initState() {
    super.initState();

    AppState initStateProvider = Provider.of<AppState>(context, listen: false);

    initStateProvider.setTempEarning(initStateProvider.isEarning,
        willNotify: false);
    initStateProvider.setTempSpending(initStateProvider.isSpending,
        willNotify: false);
    initStateProvider.setTempSearchQuery(initStateProvider.searchQuery,
        willNotify: false);
    initStateProvider.setTempDateTime(initStateProvider.dateQuery,
        willNotify: false);
    initStateProvider.setTempMinAmountQuery(initStateProvider.minAmountQuery,
        willNotify: false);
    initStateProvider.setTempMaxAmountQuery(initStateProvider.maxAmountQuery,
        willNotify: false);
    initStateProvider.setTempCashQuery(initStateProvider.isCashQuery,
        willNotify: false);
    initStateProvider.setTempCardQuery(initStateProvider.isCardQuery,
        willNotify: false);
    initStateProvider.setTempChequeQuery(initStateProvider.isChequeQuery,
        willNotify: false);
    initStateProvider.setTempAccountQuery(initStateProvider.isAccountQuery,
        willNotify: false);

    searchController.text = initStateProvider.searchQuery ?? '';
    minTextController.text = initStateProvider.minAmountQuery != -1
        ? initStateProvider.minAmountQuery.toString()
        : '';
    maxTextController.text = initStateProvider.maxAmountQuery != -1
        ? initStateProvider.maxAmountQuery.toString()
        : '';
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
          backgroundColor: Constants.profileBG,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Constants.lightGreen.withRed(210),
                                    ),
                                    height: 35.0,
                                    width: 35.0,
                                    child: Center(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Constants.primaryColor,
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
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: deviceWidth * 0.465,
                              minWidth: deviceWidth * 0.3,
                            ),
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: provider.isTempEarning,
                              onChanged: (value) {
                                provider.setTempEarning(value);
                              },
                              activeColor: Constants.primaryColor,
                              title: HeaderWidget(
                                  headerText: 'Earnings',
                                  textColor: Colors.black54,
                                  maxFontSize: 14,
                                  minFontSize: 11),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: deviceWidth * 0.47,
                              minWidth: deviceWidth * 0.3,
                            ),
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: provider.isTempSpending,
                              onChanged: (value) {
                                provider.setTempSpending(value);
                              },
                              activeColor: Constants.primaryColor,
                              title: HeaderWidget(
                                  headerText: 'Expenditures',
                                  textColor: Colors.black54,
                                  maxFontSize: 13,
                                  minFontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(10.0),
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: searchController,
                          onSaved: (value) {
                            provider.setTempSearchQuery(value,
                                willNotify: false);
                          },
                          cursorColor: Constants.primaryColor,
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
                          FocusScope.of(context).unfocus();
                          selectDate(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15.0),
                          width: deviceWidth * 0.87,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.grey)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: deviceWidth * 0.69,
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  provider.tempDateTime?.isNotEmpty ?? false
                                      ? provider.tempDateTime
                                      : 'Search By Date',
                                  style: GoogleFonts.nunito(
                                    color: provider.tempDateTime?.isNotEmpty ??
                                            false
                                        ? Colors.black54
                                        : Colors.grey.shade400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      provider.tempDateTime?.isNotEmpty ?? false
                                          ? GestureDetector(
                                              onTap: () {
                                                provider.setTempDateTime('');
                                              },
                                              child: Icon(
                                                Icons.clear,
                                                color: Colors.black45,
                                                size: 20.0,
                                              ),
                                            )
                                          : Container(),
                                      Icon(
                                        Icons.date_range,
                                        color: Colors.black45,
                                        size: 20.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
                            height: 100,
                            margin: EdgeInsets.fromLTRB(10.0, 0.0, 15.0, 0.0),
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              validator: validateNullableDoubleValue,
                              controller: minTextController,
                              maxLength: 20,
                              onSaved: (value) {
                                if (value == null || value.isEmpty) return;
                                provider
                                    .setTempMinAmountQuery(double.parse(value));
                              },
                              cursorColor: Constants.primaryColor,
                              textAlign: TextAlign.left,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                fillColor: Colors.white,
                                hintText: 'Minimum',
                                errorMaxLines: 2,
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
                            height: 100,
                            margin: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: maxTextController,
                              validator: validateNullableDoubleValue,
                              maxLength: 20,
                              onSaved: (value) {
                                if (value == null || value.isEmpty) return;
                                provider
                                    .setTempMaxAmountQuery(double.parse(value));
                              },
                              cursorColor: Constants.primaryColor,
                              textAlign: TextAlign.left,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                errorMaxLines: 2,
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
                              value: provider.isTempCashQuery,
                              onChanged: (value) {
                                provider.setTempCashQuery(value);
                              },
                              activeColor: Constants.primaryColor,
                              title: HeaderWidget(
                                  headerText: 'Cash',
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
                              value: provider.isTempCardQuery,
                              onChanged: (value) {
                                provider.setTempCardQuery(value);
                              },
                              activeColor: Constants.primaryColor,
                              title: HeaderWidget(
                                  headerText: 'Card',
                                  textColor: Colors.black54,
                                  maxFontSize: 15,
                                  minFontSize: 12),
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
                              activeColor: Constants.primaryColor,
                              title: HeaderWidget(
                                  headerText: 'Cheque',
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
                              value: provider.isTempAccountQuery,
                              onChanged: (value) {
                                provider.setTempAccountQuery(value);
                              },
                              activeColor: Constants.primaryColor,
                              title: HeaderWidget(
                                  headerText: 'Account Transfer',
                                  textColor: Colors.black54,
                                  maxFontSize: 15,
                                  minFontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.0),
                      GestureDetector(
                        onTap: () {
                          submit();
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15.0, right: 15.0),
                          padding: EdgeInsets.all(10.0),
                          width: deviceWidth * 0.8,
                          height: deviceHeight * 0.08,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Constants.buttonColor.withOpacity(0.5),
                                blurRadius: 6.0,
                                offset: Offset(2, 6),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20.0),
                            color: Constants.buttonColor,
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

  void submit() {
    final _formState = _formKey.currentState;

    if (_formState.validate()) {
      _formState.save();

      provider.setEarning(provider.isTempEarning, willNotify: false);
      provider.setSpending(provider.isTempSpending, willNotify: false);
      provider.setSearchQuery(provider.tempSearchQuery, willNotify: false);
      provider.setDateQuery(provider.tempDateTime, willNotify: false);
      provider.setMinAmountQuery(provider.tempMinAmountQuery,
          willNotify: false);
      provider.setMaxAmountQuery(provider.tempMaxAmountQuery,
          willNotify: false);
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
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
  }
}
