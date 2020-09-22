import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'HomePage.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _autovalidate = false;
  String name, address, dob, favcolor, state, color;
  DateTime date = DateTime.now();
  TextEditingController dateCtl = TextEditingController();
  bool lightTheme = true;
  Color currentColor = Colors.limeAccent;
  void changeColor(Color color) => setState(() => currentColor = color);
  String dropdownValue;

  ColorSwatch _tempMainColor;
  Color mainColor;

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => mainColor = _tempMainColor);
              },
            ),
          ],
        );
      },
    );
  }

  void _openFullMaterialColorPicker() async {
    _openDialog(
      "Color picker",
      MaterialColorPicker(
        colors: fullMaterialColors,
        selectedColor: mainColor,
        allowShades: false,
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        title: Text('Input User Detail'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _key,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/nature.png"),
                        fit: BoxFit.fill)),
                child: Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage('images/flutter.png'),
                      height: 150,
                      width: 150,
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Enter Name';
                          }
                        },
                        decoration: InputDecoration(labelText: 'Name'),
                        onSaved: (input) => name = input,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Enter Email';
                          }
                        },
                        decoration: InputDecoration(labelText: 'Email'),
                        onSaved: (input) => address = input,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.date_range),
                      title: TextFormField(
                        controller: dateCtl,
                        decoration: InputDecoration(
                          labelText: "Date of birth",
                        ),
                        onTap: () async {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.light(),
                                child: child,
                              );
                            },
                          );
                          dateCtl.text = date.toString();
                        },
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Enter Date of Birth';
                          }
                        },
                        onSaved: (input) => dob = input,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.add_to_queue),
                      title: DropDownFormField(
                        value: dropdownValue,
                        titleText: null,
                        hintText: 'Select your state',
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        dataSource: [
                          {
                            'display': 'Andhra Pradesh',
                            'value': 'Andhra Pradesh'
                          },
                          {
                            'display': "Arunachal Pradesh",
                            'value': "Arunachal Pradesh"
                          },
                          {'display': "Assam", 'value': "Assam"},
                          {'display': "Bihar", 'value': "Bihar"},
                          {'display': "Chhattisgarh", 'value': "Chhattisgarh"},
                          {'display': "Goa", 'value': "Goa"},
                          {'display': "Gujarat", 'value': "Gujarat"},
                          {'display': "Haryana", 'value': "Haryana"},
                          {
                            'display': "Himachal Pradesh",
                            'value': "Himachal Pradesh"
                          },
                          {
                            'display': "Jammu and Kashmir",
                            'value': "Jammu and Kashmir"
                          },
                          {'display': "Jharkhand", 'value': "Jharkhand"},
                          {'display': "Karnataka", 'value': "Karnataka"},
                          {'display': "Kerala", 'value': "Kerala"},
                          {
                            'display': "Madhya Pradesh",
                            'value': "Madhya Pradesh"
                          },
                          {'display': "Manipur", 'value': "Manipur"},
                          {'display': "Meghalaya", 'value': "Meghalaya"},
                          {'display': "Mizoram", 'value': "Mizoram"},
                          {'display': "Nagaland", 'value': "Nagaland"},
                          {'display': "Odisha", 'value': "Odisha"},
                          {'display': "Punjab", 'value': "Punjab"},
                          {'display': "Rajasthan", 'value': "Rajasthan"},
                          {'display': "Sikkim", 'value': "Sikkim"},
                          {'display': "Tamil Nadu", 'value': "Tamil Nadu"},
                          {'display': "Telangana", 'value': "Telangana"},
                          {'display': "Tripura", 'value': "Tripura"},
                          {'display': "Uttarakhand", 'value': "Uttarakhand"},
                          {
                            'display': "Uttar Pradesh",
                            'value': "Uttar Pradesh"
                          },
                          {'display': "West Bengal", 'value': "West Bengal"},
                          {
                            'display': "Andaman and Nicobar Islands",
                            'value': "Andaman and Nicobar Islands"
                          },
                          {'display': "Chandigarh", 'value': "Chandigarh"},
                          {
                            'display': "Dadra and Nagar Haveli",
                            'value': "Dadra and Nagar Haveli"
                          },
                          {
                            'display': "Daman and Diu",
                            'value': "Daman and Diu"
                          },
                          {'display': "Delhi", 'value': "Delhi"},
                          {'display': "Lakshadweep", 'value': "Lakshadweep"},
                          {'display': "Puducherry", 'value': "Puducherry"}
                        ],
                        textField: 'display',
                        valueField: 'value',
                        onSaved: (input) {
                          state = input;
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(90, 15, 90, 15),
                      onPressed: _openFullMaterialColorPicker,
                      child: const Text('Select your favourite color'),
                      color: mainColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    Padding(padding: EdgeInsets.all(10.0)),
                    ButtonTheme(
                      height: 40.0,
                      minWidth: 200.0,
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(100, 25, 100, 25),
                        color: Colors.blue[100],
                        onPressed: _sendtonextscreen,
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.grey[850],
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(50.0)),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  _sendtonextscreen() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            name: name,
            dob: dob,
            address: address,
            mainColor: mainColor,
            state: state,
          ),
        ),
      );
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }
}
