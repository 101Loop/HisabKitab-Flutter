import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/api_controller/transaction_api_controller.dart';
import 'package:hisabkitab/src/mixins/validator.dart';
import 'package:hisabkitab/src/models/transaction.dart';
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/src/screens/main_screen.dart';
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
      provider
          .setDateTime(DateFormat('yyyy-MM-dd').format(pickedDate).toString());
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

      initStateProvider.setDateTime(_transaction.transactionDate,
          willNotify: false);
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
                                    image: AssetImage(
                                        'assets/images/addTransactionImage.png'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          HeaderWidget(
                            headerText: 'Name *',
                            maxFontSize: 18.0,
                            minFontSize: 16.0,
                            textColor: Colors.black,
                          ),
                          SizedBox(height: 10.0),
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
                                    initialValue: _contact,
                                    validator: validateField,
                                    onSaved: (value) {
                                      _contact = value;
                                    },
                                    cursorColor: Constant.primaryColor,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(
                                          bottom: 2.0,
                                          left: 0.0,
                                          top: 0.0,
                                          right: 0.0),
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
                            height: 10.0,
                          ),
                          HeaderWidget(
                            headerText: 'Amount *',
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
                                    initialValue:
                                        _transaction?.amount?.toString() ?? '',
                                    validator: validateDoubleValue,
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
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(0.0),
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
                            headerText: 'Category *',
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
                                IgnorePointer(
                                  ignoring: _transaction != null ? false : true,
                                  child: Container(
                                    width: deviceWidth * 0.7,
                                    child: DropdownButton(
                                      iconSize: 0.0,
                                      underline: Container(),
                                      value: provider.category,
                                      onChanged: (value) {
                                        provider.setCategory(value);
                                      },
                                      items:
                                          Constant.categoryList.map((category) {
                                        return DropdownMenuItem(
                                          child: Text(category),
                                          value: category,
                                        );
                                      }).toList(),
                                    ),
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
                          SizedBox(height: 5.0),
                          HeaderWidget(
                            headerText: 'Date *',
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
                              margin:
                                  EdgeInsets.only(bottom: 15.0, right: 15.0),
                              padding: EdgeInsets.all(15.0),
                              width: deviceWidth,
                              height: deviceHeight * 0.10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Color(0xffecf8f8).withRed(210),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                            headerText: 'Mode of payment *',
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
                                    value: provider.mode,
                                    onChanged: (value) {
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
                                    initialValue: _comment,
                                    maxLength: 40,
                                    onSaved: (value) {
                                      _comment = value;
                                    },
                                    cursorColor: Constant.primaryColor,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(
                                          bottom: 2.0,
                                          left: 0.0,
                                          top: 0.0,
                                          right: 0.0),
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
                              _submit();
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.only(bottom: 15.0, right: 15.0),
                              padding: EdgeInsets.all(15.0),
                              width: deviceWidth,
                              height: deviceHeight * 0.09,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Constant.buttonColor.withOpacity(0.5),
                                    blurRadius: 6.0,
                                    offset: Offset(2, 6),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(20.0),
                                color: Constant.buttonColor,
                              ),
                              child: Center(
                                child: HeaderWidget(
                                  headerText:
                                      '+ Save ${widget.transactionType}',
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
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Constant.primaryColor),
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
    provider.setAutoValidate(true, willNotify: true);
    final _formState = _formKey.currentState;

    if (_formState.validate() &&
        (provider.dateTime.isNotEmpty ?? false) &&
        (provider.mode.isNotEmpty ?? false)) {
      provider.setLoading(true);
      _formState.save();

      TransactionDetails transactionDetails = TransactionDetails(
          amount: double.parse(_amount),
          category: provider.category[0],
          transactionDate: provider.dateTime,
          mode: Constant.paymentMap[provider.mode],
          contact: _contact,
          comments: _comment);

      TransactionApiController.addUpdateTransaction(
              transactionDetails, _transaction?.id ?? -1)
          .then((response) {
        _showSnackBar(response.message);

        //if the response is ok, then pop with a delay of 1 sec, otherwise instantly
        if (response.statusCode == 200) {
          Future.delayed(Duration(seconds: 1), () {
            provider.setLoading(false, willNotify: false);
            _goToMainScreen();
          });
        } else {
          provider.setLoading(false);
        }
      });
    } else {
      _showSnackBar('Please provide all the required information');
    }
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
    _goToMainScreen();
    return false;
  }

  ///navigates to main screen
  void _goToMainScreen() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
  }
}
