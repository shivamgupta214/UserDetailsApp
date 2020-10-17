import 'dart:async';
import 'dart:ui';
import 'package:AARVI_Support/Screens/webView.dart';
import 'package:AARVI_Support/Screens/mobile_signup_screen.dart';
import 'package:AARVI_Support/Services/otp_services.dart';
import 'package:AARVI_Support/Values/colors.dart';
import 'package:AARVI_Support/Values/fonts.dart';
import 'package:AARVI_Support/Values/images.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:sms_autofill/sms_autofill.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String mobileNumber; //Taking mobile Number as a paramater.
  OtpVerificationScreen({Key key, this.mobileNumber}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _OtpVerificationScreen();
  }
}

class _OtpVerificationScreen extends State<OtpVerificationScreen> {
  RegExp otpRegex = new RegExp(r"\d{4}"); //Regex of Otp.
  final focusNode = FocusNode(); // For the focus node for keyboard.
  String currentOtpCode; //for current otp code.
  bool sendPressed = false; //when send is pressed the bool becomes true.
  bool stopDisplayTime = false; //To stop the display of the timer.
  bool otpCodeError = false; //if error comes in otp.

  int remainSecond = 60; //remaining seconds for the otp resend.
  Timer _timer2; //timer for the remaining seconds.
  bool otpMatch = false; //true if otp matches.
  bool errorInPin = false; //true is error in pin
  var pincontroller =
      TextEditingController(); //pincontroller for the PinAutoFill
  bool verfied = false; //true if otp verified.
  bool enterManually = false; //true if enter manually clicked.
  OTP _otpveri = OTP();
  bool _isVerifying = false;

  @override
  void initState() {
    // displayPopup(); // autheticating popup
    displayPopup2(); //function remain second
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer2.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MobileSignupScreen()),
            (route) => false);
        return;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Appcolor.primaryBackground,
        body: _isVerifying
            ? Center(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Container(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.05),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(50, 19, 27, 0.4),
                    ),
                    child: Center(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width * 0.085)),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(50, 100, 50, 100),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Verifying...",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.all(30),
                                      child: Icon(
                                        Icons.shopping_cart,
                                        color: Colors.red,
                                        size: 50,
                                      )),
                                ])),
                      ),
                    ),
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Stack(children: [
                  Container(
                    child: SafeArea(
                      child: Column(
                        children: [
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: height * 0.004,
                                ),
                                Image.asset(
                                  Images.logo, //AARVI logo
                                  height: height * 0.0675,
                                  width: width * 0.12,
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: IconButton(
                                        iconSize: height * 0.03,
                                        onPressed: () async {
                                          return Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MobileSignupScreen())); //redirecting to MobileSignupScreen
                                        },
                                        icon: Icon(
                                          Icons.arrow_back_ios,
                                          size: width * 0.05,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Verification Code",
                                          style: TextStyle(
                                              fontFamily: Fonts.montserrat,
                                              fontWeight: FontWeight.bold,
                                              fontSize: textScale * 22),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: height * 0.03,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.04,
                                ),
                                Text(
                                  "We have send SMS on +91 xxxxx xxxxx",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: Fonts.montserrat,
                                      color: Appcolor.primaryGrayBackground,
                                      fontSize: textScale * 12),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "number.",
                                      style: TextStyle(
                                          fontFamily: Fonts.montserrat,
                                          color: Appcolor.primaryGrayBackground,
                                          fontSize: textScale * 12),
                                    ),
                                    InkWell(
                                      child: Text(
                                        "Wrong Number?",
                                        style: TextStyle(
                                            fontFamily: Fonts.montserrat,
                                            decoration: otpCodeError
                                                ? TextDecoration.underline
                                                : TextDecoration.none,
                                            color:
                                                Appcolor.primaryRedisBackground,
                                            fontSize: textScale * 12),
                                      ),
                                      onTap: () async {
                                        return Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MobileSignupScreen())); //to go back to MobileSignUp screen if wrong number
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  child: PinFieldAutoFill(
                                    //package for autofill.
                                    focusNode: focusNode,

                                    controller: pincontroller,
                                    textInputAction: TextInputAction.done,
                                    decoration: BoxLooseDecoration(
                                        bgColorBuilder:
                                            FixedColorBuilder(Colors.white),
                                        gapSpaces: [15, 15, 15],
                                        textStyle: otpCodeError
                                            ? TextStyle(color: Colors.red)
                                            : TextStyle(color: Colors.black),
                                        strokeWidth: 0.0,
                                        strokeColorBuilder:
                                            PinListenColorBuilder(
                                                Colors.white, Colors.white)),
                                    currentCode:
                                        currentOtpCode, // prefill with a code
                                    //code submitted callback
                                    onCodeChanged: (receivedOTP) {
                                      currentOtpCode = receivedOTP;
                                    }, //code changed callback
                                    codeLength: 4, //
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.038,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              stopDisplayTime
                                  ? RichText(
                                      text: TextSpan(
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              setState(() {
                                                print('object');
                                                stopDisplayTime = true;
                                              });
                                              print(int.parse(
                                                  widget.mobileNumber));
                                              var response = await _otpveri
                                                  .resendOtp(int.parse(
                                                      widget.mobileNumber));
                                              print(response);
                                              print(response.statusCode);

                                              Fluttertoast.showToast(
                                                  msg: "OTP resent!",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            },
                                          text: "Resend OTP",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16 * textScale,
                                            fontFamily: Fonts.montserrat,
                                          )),
                                    )
                                  : Text(
                                      "OTP in 00:$remainSecond",
                                      style: TextStyle(
                                        fontFamily: Fonts.montserrat,
                                      ),
                                    ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.04),
                            child: RaisedButton(
                                color: Appcolor.primaryRedisBackground,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: height * 0.07,
                                  child: Text(
                                    "VERIFY OTP",
                                    style: TextStyle(
                                        fontFamily: Fonts.montserrat,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(height * 0.015)),
                                disabledColor: Appcolor.primaryRedisBackground,
                                onPressed: () async {
                                  setState(() {
                                    _isVerifying = true;
                                  });
                                  Response response;
                                  Dio dio = new Dio();
                                  dio.options.headers = {
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                  };
                                  FormData formData = new FormData.fromMap({
                                    "otp": pincontroller.text,
                                    "mobileNo": int.parse(widget.mobileNumber),
                                  });
                                  try {
                                    response = await dio.post(
                                        "https://ic7rr83t79.execute-api.ap-south-1.amazonaws.com/Prod/api/verify",
                                        data: formData);
                                    print(response.statusCode);
                                    print('45');
                                    displayDialog('assets/images/check.png',
                                        response.toString());
                                    print(response.data.toString());
                                    setState(() {
                                      _isVerifying = false;
                                    });
                                  } catch (error) {
                                    print('60');
                                    setState(() {
                                      _isVerifying = false;
                                    });
                                    throw displayErrorDialog(
                                        'assets/images/warning.png');
                                  }
                                }),
                            // focusNode.unfocus();
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
      ),
    );
  }

  void displayPopup2() {
    //called for starting the timer for the otp resend.
    _timer2 = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainSecond <= 0) {
        timer.cancel();
        setState(() {
          stopDisplayTime = true;
        });
      } else {
        setState(() {
          remainSecond = remainSecond - 1;
        });
      }
      // if (pincontroller.text.length > 0) {
      //   timer.cancel();
      //   setState(() {
      //     stopDisplayTime = true;
      //   });
      // }
    });
  }

  Future displayDialog(
    // called when submit button is clicked.
    //called for the resend dialog or the success dialog.
    String imageUrl,
    String msg,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              decoration: BoxDecoration(
                color: Color.fromRGBO(50, 19, 27, 0.4),
              ),
              child: Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.085)),
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.05),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Success",
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  22 * MediaQuery.of(context).textScaleFactor),
                        ),
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.02),
                          child: Image.asset(
                            imageUrl,
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: MediaQuery.of(context).size.width * 0.4,
                            fit: BoxFit.contain,
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text:
                                  "Congratulation, Partner number is verify and your partner id is ",
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).textScaleFactor *
                                          15),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "$msg",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context)
                                                .textScaleFactor *
                                            15))
                              ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RaisedButton(
                          child: Text(
                            'Copy ID',
                            style: TextStyle(color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            ClipboardManager.copyToClipBoard(msg);
                            Fluttertoast.showToast(
                                msg: "ID copied",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WebViewPage()),
                                (route) => false);
                          },
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future displayErrorDialog(
    // called when submit button is clicked.
    //called for the resend dialog or the success dialog.
    String imageUrl,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              decoration: BoxDecoration(
                color: Color.fromRGBO(50, 19, 27, 0.4),
              ),
              child: Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.085)),
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.05),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Failed!",
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  22 * MediaQuery.of(context).textScaleFactor),
                        ),
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.02),
                          child: Image.asset(
                            imageUrl,
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: MediaQuery.of(context).size.width * 0.4,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          "Sorry, your OTP is wrong!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).textScaleFactor * 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RaisedButton(
                          child: Text(
                            'Retry',
                            style: TextStyle(color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future displayVerifyDialog() {
    return showDialog(context: context);
  }
}
