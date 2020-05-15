import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hisabkitab/src/api_controller/transaction_api_controller.dart';
import 'package:hisabkitab/src/mixins/validator.dart';
import 'package:hisabkitab/src/models/transaction.dart';
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/src/screens/main_screen.dart';
import 'package:hisabkitab/utils/app_localizations.dart';
import 'package:hisabkitab/utils/baked_icons/rupee_icon_icons.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/const.dart' as Constant;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddTransaction extends StatefulWidget {
  AddTransaction({
    Key key,
    @required this.transactionType,
    this.category = '',
    this.transaction,
  }) : super(key: key);

  final String transactionType;
  final TransactionDetails transaction;
  final String category;

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> with ValidationMixin {
  double deviceHeight;
  double deviceWidth;

  String date;

  final _formKey = GlobalKey<FormState>();

  AppState provider;

  String _amount;
  String _contact;
  String _comment;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TransactionDetails _transaction;

  AppLocalizations appLocalizations;

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
      provider.setDateTime(DateFormat('yyyy-MM-dd').format(pickedDate).toString());
    }
  }

  @override
  void initState() {
    super.initState();

    _transaction = widget.transaction;

    AppState initStateProvider = Provider.of<AppState>(context, listen: false);
    initStateProvider.initialState();
    if (_transaction != null) {
      if (_transaction.category == 'C') {
        initStateProvider.setCategory('Credit', willNotify: false);
      } else {
        initStateProvider.setCategory('Debit', willNotify: false);
      }

      initStateProvider.setDateTime(_transaction.transactionDate, willNotify: false);
      initStateProvider.setMode(_transaction.mode?.mode, willNotify: false);
      _contact = _transaction.contact?.name ?? '';
      _comment = _transaction.comments ?? '';
    } else {
      initStateProvider.setCategory(widget.category, willNotify: false);
      initStateProvider.setDateTime('', willNotify: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context);
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    provider = Provider.of<AppState>(context);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: IgnorePointer(
            ignoring: provider.isLoading,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 0.0, 0.0),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Constant.lightGreen.withRed(210),
                              ),
                              height: 35.0,
                              width: 35.0,
                              child: Center(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Constant.primaryColor,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    provider.setNeedsUpdate(false, willNotify: false);
                                    _goToMainScreen();
                                  },
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              HeaderWidget(
                                headerText: widget.transactionType,
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
                                    image: AssetImage('assets/images/addTransactionImage.png'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          HeaderWidget(
                            headerText: appLocalizations.translate('name') + ' *',
                            maxFontSize: 18.0,
                            minFontSize: 16.0,
                            textColor: Colors.black,
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            margin: EdgeInsets.only(bottom: 15.0, right: 15.0),
                            padding: EdgeInsets.only(left: 15, bottom: 8, right: 8, top: 8),
                            width: deviceWidth,
                            height: 67,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Color(0xffecf8f8).withRed(210),
                            ),
                            child: Container(
                              child: TextFormField(
                                initialValue: _contact,
                                validator: (value) {
                                  String result = validateField(value);
                                  if (result != null)
                                    return appLocalizations.translate(result);
                                  else
                                    return result;
                                },
                                autovalidate: provider.autoValidate,
                                onSaved: (value) {
                                  _contact = value;
                                },
                                cursorColor: Constant.primaryColor,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.comment,
                                    color: Colors.black45,
                                    size: 20.0,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(bottom: 0.0, left: 0.0, top: 14.0, right: 0.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          HeaderWidget(
                            headerText: appLocalizations.translate('amount') + ' *',
                            maxFontSize: 18.0,
                            minFontSize: 16.0,
                            textColor: Colors.black,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 15.0, right: 15.0),
                            padding: EdgeInsets.only(left: 15, bottom: 8, right: 8, top: 8),
                            width: deviceWidth,
                            height: 67,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Color(0xffecf8f8).withRed(210),
                            ),
                            child: Container(
                              child: TextFormField(
                                initialValue: _transaction?.amount?.toString() ?? '',
                                validator: (value) {
                                  String result = validateDoubleValue(value);
                                  if (result != null)
                                    return appLocalizations.translate(result);
                                  else
                                    return result;
                                },
                                autovalidate: provider.autoValidate,
                                onSaved: (value) {
                                  _amount = value;
                                },
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(20),
                                ],
                                keyboardType: TextInputType.number,
                                cursorColor: Constant.primaryColor,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    RupeeIcon.rupee_icon,
                                    color: Colors.black45,
                                    size: 16.0,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(bottom: 0.0, left: 0.0, top: 14.0, right: 0.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          HeaderWidget(
                            headerText: appLocalizations.translate('category') + ' *',
                            maxFontSize: 18.0,
                            minFontSize: 16,
                            textColor: Colors.black,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 15.0, right: 15.0),
                            padding: EdgeInsets.only(bottom: 8, right: 8, top: 8),
                            width: deviceWidth,
                            height: 67,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Color(0xffecf8f8).withRed(210),
                            ),
                            child: IgnorePointer(
                              ignoring: _transaction != null ? false : true,
                              child: SizedBox(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton(
                                    icon: _transaction != null
                                        ? Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.black45,
                                            size: 30.0,
                                          )
                                        : Icon(
                                            Icons.list,
                                            color: Colors.black45,
                                            size: 28.0,
                                          ),
                                    isExpanded: true,
                                    underline: Container(),
                                    value: provider.category,
                                    onChanged: (value) {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      provider.setCategory(value);
                                    },
                                    items: Constant.categoryList.map((category) {
                                      return DropdownMenuItem(
                                        child: Text(category),
                                        value: category,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          HeaderWidget(
                            headerText: appLocalizations.translate('date') + ' *',
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
                              height: 67,
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
                                      provider.dateTime ?? '',
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
                            headerText: appLocalizations.translate('modeOfPayment') + ' *',
                            maxFontSize: 18.0,
                            minFontSize: 16,
                            textColor: Colors.black,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 15.0, right: 15.0),
                            padding: EdgeInsets.only(bottom: 8, right: 8, top: 8),
                            width: deviceWidth,
                            height: 67,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Color(0xffecf8f8).withRed(210),
                            ),
                            child: Container(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    size: 30,
                                    color: Colors.black45,
                                  ),
                                  underline: Container(),
                                  value: provider.mode,
                                  onChanged: (value) {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    provider.setMode(value);
                                  },
                                  items: Constant.paymentList.map((mode) {
                                    return DropdownMenuItem(
                                      child: Text(mode),
                                      value: mode,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          HeaderWidget(
                            headerText: appLocalizations.translate('comment'),
                            maxFontSize: 18.0,
                            minFontSize: 16.0,
                            textColor: Colors.black,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 15.0, right: 15.0),
                            padding: EdgeInsets.only(left: 15, bottom: 5.0, right: 8.0, top: 5.0),
                            width: deviceWidth,
                            height: 67,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Color(0xffecf8f8).withRed(210),
                            ),
                            child: Container(
                              width: deviceWidth * 0.763,
                              child: TextFormField(
                                initialValue: _comment,
                                maxLength: 30,
                                onSaved: (value) {
                                  _comment = value;
                                },
                                cursorColor: Constant.primaryColor,
                                decoration: InputDecoration(
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Icon(
                                      Icons.comment,
                                      color: Colors.black45,
                                      size: 20.0,
                                    ),
                                  ),
                                  counterStyle: TextStyle(fontSize: 10),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(bottom: 0.0, left: 0.0, top: 22.0, right: 0.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              _submit();
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 15.0, right: 15.0),
                              padding: EdgeInsets.all(15.0),
                              width: deviceWidth,
                              height: 65,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Constant.buttonColor.withOpacity(0.5),
                                    blurRadius: 6.0,
                                    offset: Offset(2, 6),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(20.0),
                                color: Constant.buttonColor,
                              ),
                              child: Center(
                                child: HeaderWidget(
                                  headerText: appLocalizations.translate('saveTransaction'),
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
                provider.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Constant.primaryColor),
                      ))
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();

    provider.setTransactionType('', willNotify: false);
    provider.setMode(null, willNotify: false);
  }

  void _submit() {
    provider.setAutoValidate(true);
    final _formState = _formKey.currentState;

    if (_formState.validate() && (provider?.dateTime?.isNotEmpty ?? false) && (provider?.mode?.isNotEmpty ?? false)) {
      provider.setLoading(true);
      _formState.save();

      TransactionDetails transactionDetails = TransactionDetails(
          amount: double.parse(_amount), category: provider.category[0], transactionDate: provider.dateTime, mode: Constant.paymentMap[provider.mode], contact: _contact, comments: _comment);

      TransactionApiController.addUpdateTransaction(transactionDetails, _transaction?.id ?? -1).then((response) {
        String message;
        if (response.statusCode == 200 || response.statusCode == 0)
          message = appLocalizations.translate(response.message);
        else
          message = response.message;

        _showSnackBar(message);

        //if the response is ok, then pop with a delay of 1 sec, otherwise instantly
        if (response.statusCode == 200) {
          Future.delayed(Duration(seconds: 1), () {
            provider.setLoading(false, willNotify: false);
            provider.setNeedsUpdate(true, willNotify: false);
            _goToMainScreen();
          });
        } else {
          provider.setLoading(false);
        }
      });
    } else {
      _showSnackBar(appLocalizations.translate('provideAllInfo'));
    }
  }

  String changeTransactionName(String name) {
    return name.split(' ')[1];
  }

  ///shows a toast with message [message]
  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  ///navigates to main screen on pressing back button
  ///always returns false, to prevent popping the screen
  Future<bool> _onBackPressed() async {
    provider.setNeedsUpdate(false, willNotify: false);
    _goToMainScreen();
    return false;
  }

  ///navigates to main screen
  void _goToMainScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
  }
}
