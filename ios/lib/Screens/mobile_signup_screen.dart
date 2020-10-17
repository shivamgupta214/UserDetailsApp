import 'package:AARVI_Support/Screens/otp_verification_screen.dart';
import 'package:AARVI_Support/Values/colors.dart';
import 'package:AARVI_Support/Values/fonts.dart';
import 'package:AARVI_Support/Values/images.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MobileSignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MobileSignupScreen();
  }
}

class _MobileSignupScreen extends State<MobileSignupScreen> {
  final peresonNumberController =
      TextEditingController(); //Controller for the number text field.
  final RegExp personNumberRegex =
      new RegExp(r'^\d{10}$'); //regex for mobile number.
  var _isLoading = false;
  bool personNumberError = false; //bool for the error in the entering number.
  final _formKey = GlobalKey<FormState>(); //form key for the textfield.
  // MobileSignUp _mobileSignUp = new MobileSignUp();

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height; //height and width of the screen.
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return;
      },
      child: Scaffold(
        resizeToAvoidBottomInset:
            false, //body will not resize when an onScreen keyboard opens.
        body: Container(
          height: height,
          width: width,
          child: _isLoading
              ? Center(
                  child: SpinKitWave(
                      size: 100,
                      color: Colors.red,
                      type: SpinKitWaveType.center),
                )
              : new Column(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(top: height * 0.1),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              child: Image.asset(
                                  Images.logo, //image of AARVI logo.
                                  height: height * 0.23,
                                  fit: BoxFit.fill),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.004,
                                  ),
                                  Text(
                                    "Namaste",
                                    style: TextStyle(
                                      fontFamily: Fonts.montserrat,
                                      fontSize: 25 *
                                          MediaQuery.textScaleFactorOf(context),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.008),
                                  Container(
                                    padding: EdgeInsets.all(width * 0.05),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Enter 10 digits Mobile number",
                                          style: TextStyle(
                                              fontSize: 13 *
                                                  MediaQuery.of(context)
                                                      .textScaleFactor,
                                              fontFamily: Fonts.montserrat,
                                              color: Colors.black),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                flex: 2,
                                                child: TextFormField(
                                                  enabled: false,
                                                  decoration: InputDecoration(
                                                      disabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.red,
                                                            width: 1),
                                                      ),
                                                      hintText: "+91",
                                                      hintStyle: TextStyle(
                                                          color: Colors.black)),
                                                )),
                                            SizedBox(
                                              width: width * 0.03,
                                            ),
                                            Form(
                                              key: _formKey,
                                              child: Expanded(
                                                flex: 15,
                                                child: TextFormField(
                                                    controller:
                                                        peresonNumberController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.red,
                                                            width: 1),
                                                      ),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.red,
                                                            width: 1),
                                                      ),
                                                      hintText: "1234567890",
                                                    ),
                                                    style:
                                                        personNumberError //if personNumberError is true then show red color.
                                                            ? TextStyle(
                                                                color:
                                                                    Colors.red)
                                                            : TextStyle(
                                                                color: Colors
                                                                    .black),
                                                    onChanged: (value) {
                                                      if (personNumberRegex
                                                          .hasMatch(value)) {
                                                        print('6');
                                                        setState(() {
                                                          personNumberError =
                                                              false;
                                                        });
                                                      }
                                                      if (value.isEmpty) {
                                                        print('shivam');
                                                        setState(() {
                                                          personNumberError =
                                                              true;
                                                        });
                                                        return;
                                                      }
                                                    },
                                                    validator: (value) {
                                                      //validates the mobile number regex.
                                                      if (value.isEmpty) {
                                                        AlertDialog(
                                                          title: Text(
                                                              'Enter Mobile number'),
                                                        );
                                                        return;
                                                      }
                                                      var numV =
                                                          int.tryParse(value);
                                                      if (numV >= 0 &&
                                                          numV < 5999999999) {
                                                        print('1');
                                                        setState(() {
                                                          personNumberError =
                                                              true;
                                                        });
                                                        return;
                                                      }
                                                      if (!personNumberRegex
                                                          .hasMatch(value)) {
                                                        print('2');
                                                        setState(() {
                                                          personNumberError =
                                                              true;
                                                        });
                                                        return;
                                                      } else {
                                                        print('3');
                                                        setState(() {
                                                          personNumberError =
                                                              false;
                                                        });
                                                        return;
                                                      }
                                                    }),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * 0.04,
                                        ),
                                        RaisedButton(
                                          color:
                                              Appcolor.primaryRedisBackground,
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: height * 0.07,
                                            child: Text(
                                              "SEND OTP",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          onPressed: () async {
                                            print(personNumberError);
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            _formKey.currentState
                                                .save(); //saves the current state and validates it.
                                            if (_formKey.currentState
                                                    .validate() &&
                                                !personNumberError) {
                                              _signUp(int.parse(
                                                  peresonNumberController
                                                      .text));
                                            } else {
                                              Fluttertoast.showToast(
                                                  //for the error of the number validation.
                                                  msg:
                                                      "Enter Proper Mobile Number",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                              // }
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            }
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      height * 0.015)),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  _signUp(int mobileno) async {
    Response response;
    Dio dio = new Dio();
    dio.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    FormData formData = new FormData.fromMap({
      "MobileNo": mobileno,
    });
    try {
      response = await dio.post(
          "https://ic7rr83t79.execute-api.ap-south-1.amazonaws.com/Prod/api/sendsms",
          data: formData);
      print(response.statusCode);
      print(response.data.toString());
      Fluttertoast.showToast(
          //for the error of the number validation.
          msg: "OTP sent",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(
          //navigating to OtpVerification Screen/
          context,
          MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(
                    mobileNumber: peresonNumberController.text,
                  )));
      // } on HttpException catch (error) {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   var errorMessage = 'Failed';
      //   if (error.toString().contains('Please enter correct Mobile Number')) {
      //     errorMessage = 'Please enter correct Mobile Number';
      //     print(errorMessage);
      //     print('120');
      //   }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // print(e.data.toString());
      // print('0000');
      Fluttertoast.showToast(
          msg: "Mobile no is already registered",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
