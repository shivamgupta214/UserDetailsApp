import 'dart:ui';

import 'package:AARVI_Support/Screens/webView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Values/images.dart';

class ExitPage extends StatefulWidget {
  @override
  _ExitPageState createState() => _ExitPageState();
}

class _ExitPageState extends State<ExitPage> {
  exit(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(50, 19, 27, 0.4),
              ),
              child: Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Confirm Exit",
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Image.asset(
                          "assets/images/warning.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          "Are you sure you want to exit?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FlatButton(
                              child: Text(
                                'No',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => WebViewPage()),
                                    (route) => false);
                              },
                            ),
                            FlatButton(
                              child: Text(
                                'Yes',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                              onPressed: () {
                                SystemNavigator.pop();
                              },
                            ),
                          ],
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

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => exit(context));
    return Scaffold(
        appBar: AppBar(
          title: Text('Submit Feedback'),
          backgroundColor: Colors.red,
        ),
        body: Center());
  }
}
