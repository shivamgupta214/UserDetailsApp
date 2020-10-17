import 'dart:ui';

import 'package:AARVI_Support/Screens/otp_verification_screen.dart';
import 'package:AARVI_Support/model/httpexception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class OTP {
  OtpVerificationScreen _screen = OtpVerificationScreen();
  resendOtp(int mobileNew) async {
    Response response;
    Dio dio = new Dio();
    dio.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    FormData formData = new FormData.fromMap({
      "mobileNo": mobileNew,
    });
    try {
      response = await dio.post(
          "https://ic7rr83t79.execute-api.ap-south-1.amazonaws.com/Prod/api/resendsms",
          data: formData);
      print(response.statusCode);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
