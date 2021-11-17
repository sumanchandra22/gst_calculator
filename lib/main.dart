import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme:
          ThemeData(primarySwatch: Colors.teal, accentColor: Colors.tealAccent),
      home: Form(),
    );
  }
}
class Form extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<Form> {


  void _reset() {
    totalTextEditingController.text = "";
    discountTextEditingController.text = "";
    sgstTextEditingController.text = "";
    cgstTextEditingController.text = "";
    result = "";
    currentValue = _discounttype[0];
  }

  // dialog box

  void onDialogOpen(BuildContext context, String s) {
    var alertDialog = AlertDialog(
      title: Text("RESULTS"),
      content: Text(s),
      backgroundColor: Colors.green,
      elevation: 8.0,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(s),
          );
        });
  }

  // controller
  TextEditingController totalTextEditingController =
  TextEditingController();
  TextEditingController sgstTextEditingController =
  TextEditingController();
  TextEditingController cgstTextEditingController =
  TextEditingController();
  TextEditingController discountTextEditingController =
  TextEditingController();

  // _discounttype
  var _discounttype = ['Rupees', 'Percentage'];

  String result = "";
  String currentValue = "";
  String nv = "";

  @override
  void initState() {
    currentValue = _discounttype[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Calculator",
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: ListView(
          children: <Widget>[
            //image
            getImage(),

            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                controller: totalTextEditingController,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: "Total Amount",
                    hintText: "Enter the total amount.",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
              ),
            ),


            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
                      controller: discountTextEditingController,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: "Discount",
                          hintText: "Enter the discount in percentage",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                  ),
                ),
                Container(
                  width: 10,
                ),

                // dropdown menu
                Expanded(
                  child: DropdownButton<String>(
                    items: _discounttype.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: currentValue,
                    onChanged: (String newValue) {
                      _setSelectedValue(newValue);
                      this.nv = newValue;
                      setState(() {
                        this.currentValue = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                controller: sgstTextEditingController,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: "SGST",
                    hintText: "Enter the SGST percentage.",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                controller: cgstTextEditingController,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: "CGST",
                    hintText: "Enter the CGST percentage",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
              ),
            ),

            Row(
              children: <Widget>[
                Expanded(
                    child: RaisedButton(
                      color: Colors.tealAccent,
                      textColor: Colors.black,
                      child: Text(
                        "CALCULATE",
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        this.result = _getEffectiveAmount(this.nv);
                        onDialogOpen(context, this.result);
                      },
                    )),
                Container(
                  width: 10,
                ),
                Expanded(
                    child: RaisedButton(
                      color: Colors.tealAccent,
                      textColor: Colors.black,
                      child: Text(
                        "RESET",
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        _reset();
                      },
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _setSelectedValue(String newValue) {
    setState(() {
      this.currentValue = newValue;
    });
  }

  String _getEffectiveAmount(String newValue) {
    String newResult;
    double total_amount = double.parse(totalTextEditingController.text);
    double discount = double.parse(discountTextEditingController.text);
    double sgst = double.parse(sgstTextEditingController.text);
    double cgst = double.parse(cgstTextEditingController.text);
    double netpayableAmount = 0;

    if (currentValue == _discounttype[0]) {
      netpayableAmount = (total_amount - discount) +
          ((total_amount - discount) * (sgst + cgst) / 100);
    } else if (currentValue == _discounttype[1]) {
      netpayableAmount = ((total_amount - ((discount * total_amount) / 100))) +
          ((total_amount - ((discount * total_amount) / 100)) * (sgst + cgst) /
              100);
    }
    newResult = netpayableAmount.toString();
    return newResult;
  }

  Widget getImage() {
    AssetImage assetImage = AssetImage("assets/back.png");
    Image image = Image(
      image: assetImage,
      width: 150,
      height: 150,
    );

    return Container(
      child: image,
      margin: EdgeInsets.all(30),
    );
  }
}
