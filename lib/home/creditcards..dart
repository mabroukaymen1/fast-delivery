import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class PaymentCardForm extends StatefulWidget {
  final PaymentCard? initialCard;

  PaymentCardForm({this.initialCard});

  @override
  _PaymentCardFormState createState() => _PaymentCardFormState();
}

class _PaymentCardFormState extends State<PaymentCardForm> {
  final _formKey = GlobalKey<FormState>();
  final _ownerController = TextEditingController();
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _showDetails = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    if (widget.initialCard != null) {
      _ownerController.text = widget.initialCard!.owner;
      _numberController.text = widget.initialCard!.number;
      _expiryController.text = widget.initialCard!.expiry;
      _cvvController.text = widget.initialCard!.cvv;
    }
  }

  @override
  void dispose() {
    _ownerController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _saveCardDetailsLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cardOwner', _ownerController.text);
    prefs.setString('cardNumber', _numberController.text);
    prefs.setString('cardExpiry', _expiryController.text);
    prefs.setString('cardCVV', _cvvController.text);

    _displayToastMessage("Card details saved successfully");
  }

  void _displayToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: label,
      prefixIcon: Icon(icon, color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide.none,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Payment Method",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildCardNumberField() {
    return TextFormField(
      controller: _numberController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(16),
        MaskedInputFormatter('#### #### #### ####'),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter card number';
        return null;
      },
      decoration:
          _buildInputDecoration('Card Number', Icons.credit_card_outlined),
    );
  }

  Widget _buildExpiryDateField() {
    return TextFormField(
      controller: _expiryController,
      keyboardType: TextInputType.datetime,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(5),
        MaskedInputFormatter('##/##'),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter expiry date';
        return null;
      },
      decoration:
          _buildInputDecoration('Expiry Date (MM/YY)', Icons.calendar_today),
    );
  }

  Widget _buildCVVField() {
    return TextFormField(
      controller: _cvvController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter CVV';
        return null;
      },
      decoration: _buildInputDecoration('CVV', Icons.lock),
    );
  }

  Widget _buildOwnerField() {
    return TextFormField(
      controller: _ownerController,
      validator: (value) =>
          value == null || value.isEmpty ? 'Enter owner name' : null,
      decoration: _buildInputDecoration('Card Owner', Icons.person),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveForm,
      child: Text(
        'Save Card',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _saveCardDetailsLocally();
      setState(() {
        _showDetails = true;
      });
    } else {
      _displayToastMessage('Please correct the errors in the form.');
    }
  }

  Widget _buildCardDisplay() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _ownerController.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            _numberController.text.replaceAllMapped(
                RegExp(r".{4}"), (match) => "${match.group(0)} "),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Exp: ${_expiryController.text}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "CVV: ${_cvvController.text}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            _buildOwnerField(),
            SizedBox(height: 20),
            _buildCardNumberField(),
            SizedBox(height: 20),
            _buildExpiryDateField(),
            SizedBox(height: 20),
            _buildCVVField(),
            SizedBox(height: 20),
            _buildSaveButton(),
            SizedBox(height: 20),
            if (_showDetails) _buildCardDisplay(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentCard {
  final String owner;
  final String number;
  final String expiry;
  final String cvv;

  PaymentCard({
    required this.owner,
    required this.number,
    required this.expiry,
    required this.cvv,
  });
}
