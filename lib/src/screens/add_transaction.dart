import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hisabkitab/src/api_controller/api_controller.dart';
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

  /// Type of the transaction, either earning or expense
  final String transactionType;

  /// Holds the transaction's details, passed from the previous screen
  final TransactionDetails transaction;

  /// Category under which the transaction lies, either credit or debit
  final String category;

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> with ValidationMixin {
  /// Device's height and width
  double deviceHeight;
  double deviceWidth;

  /// Holds the selected date
  String date;

  /// Global key to validate the form
  final _formKey = GlobalKey<FormState>();

  /// Holds the app's state
  AppState provider;

  /// Amount of the transaction
  String _amount;

  /// Holds the transaction's name
  String _contact;

  /// Holds the comment made upon the transaction
  String _comment;

  /// Global key for scaffold, used to show the [SnackBar]
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// A copy of passed transaction details
  TransactionDetails _transaction;

  /// Instance of [AppLocalizations] to get the translated word
  AppLocalizations appLocalizations;

  /// Is it the first build?
  ///
  /// Used to prevent unnecessary UI builds
  bool isFirstBuild = true;

  @override
  void initState() {
    super.initState();

    /// Copies the passed transaction details
    _transaction = widget.transaction;

    AppState initStateProvider = Provider.of<AppState>(context, listen: false);

    /// Sets the details in the placeholders, if the transaction details is passed
    if (_transaction != null) {
      initStateProvider.setDateTime(_transaction.transactionDate, willNotify: false);
      _contact = _transaction.contact?.name ?? '';
      _comment = _transaction.comments ?? '';

      String mode = getModeKey(_transaction.mode?.mode);
      initStateProvider.setMode(mode, willNotify: false);

      if (_transaction.category == 'C') {
        initStateProvider.setCategory('credit', willNotify: false);
      } else {
        initStateProvider.setCategory('debit', willNotify: false);
      }
    }

    /// Sets the category and date, if a new transaction is to be added
    else {
      initStateProvider.setCategory(widget.category, willNotify: false);
      initStateProvider.setMode('cash', willNotify: false);
      initStateProvider.setDateTime(DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppState>(context);
    appLocalizations = AppLocalizations.of(context);
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

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
                                headerText: appLocalizations.translate(widget.transactionType),
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
                                  String result = ValidationMixin.validateField(value);
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
                                  String result = ValidationMixin.validateDoubleValue(value);
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
                                    mode = getModeKey(mode);

                                    return DropdownMenuItem(
                                      child: Text(appLocalizations.translate(mode)),
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
                                        child: Text(appLocalizations.translate(category)),
                                        value: category,
                                      );
                                    }).toList(),
                                  ),
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

    /// Sets the default transaction type and mode upon being removed from the widget tree
    provider.setTransactionType('', willNotify: false);
    provider.setMode(null, willNotify: false);
  }

  /// Validates and adds or updates the transaction
  void _submit() {
    /// Makes the field validate on every single change
    provider.setAutoValidate(true);

    final _formState = _formKey.currentState;

    /// Validates the form details and the other details as well
    if (_formState.validate() && (provider?.dateTime?.isNotEmpty ?? false) && (provider?.mode?.isNotEmpty ?? false)) {
      /// Displays the progress loader
      provider.setLoading(true);

      /// This basically calls the onSaved() method in [TextFormField], a callback function where the field data is saved
      _formState.save();

      /// Creates an instance of [TransactionDetails] from the entered fields
      TransactionDetails transactionDetails = TransactionDetails(
          amount: double.parse(_amount),
          category: provider.category[0].toUpperCase(),
          transactionDate: provider.dateTime,
          mode: Constant.paymentMap[provider.mode],
          contact: _contact,
          comments: _comment);

      /// Calls the API and handles the response
      APIController.addUpdateTransaction(transactionDetails, _transaction?.id ?? -1).then((response) {
        String message;
        if (response.statusCode == 200 || response.statusCode == 0)
          message = appLocalizations.translate(response.message);
        else
          message = response.message;

        _showSnackBar(message);

        /// If the response is ok, then pop with a delay of 1 sec, otherwise instantly
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

  /// Shows a toast with a [message]
  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Navigates to main screen on pressing back button
  ///
  /// Always returns false, to prevent popping the screen
  Future<bool> _onBackPressed() async {
    provider.setNeedsUpdate(false, willNotify: false);
    _goToMainScreen();
    return false;
  }

  /// Navigates to main screen
  void _goToMainScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
  }

  /// Returns key for modes
  String getModeKey(String mode) {
    if (mode == 'Account Transfer')
      return 'accountTransfer';
    else
      return mode.toLowerCase();
  }

  /// Displays and sets the date
  Future<Null> selectDate(BuildContext context) async {
    /// Sets the initial date to be shown in the date picker
    DateTime initDate = DateTime.now();
    if(provider.dateTime != null && provider.dateTime.isNotEmpty)
      initDate = DateFormat('yyyy-MM-dd').parse(provider.dateTime);

    /// Gets the selected date from the date picker
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime.now().subtract(
        Duration(days: 30),
      ),
      lastDate: DateTime.now(),
    );

    /// Sets the date in the app's state
    if (pickedDate != null) {
      provider.setDateTime(DateFormat('yyyy-MM-dd').format(pickedDate).toString());
    }
  }
}
