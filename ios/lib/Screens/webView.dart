import 'dart:async';

import 'package:AARVI_Support/Screens/exitPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

// http://volvere.in/aarvicollaborator
class _WebViewPageState extends State<WebViewPage> {
  // InAppWebViewController webView;
  final FlutterWebviewPlugin webView = new FlutterWebviewPlugin();
  StreamSubscription _onBack;

  @override
  void initState() {
    super.initState();

    _onBack = webView.onBack.listen((event) {
      SystemNavigator.pop();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _onBack.cancel();
  }

  // onBack() async {
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // return WillPopScope(
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: Text('Submit Feedback'),
      ),
      body: Center(
        child: WebviewScaffold(
          // androidOnPermissionRequest: (InAppWebViewController controller,
          //     String origin, List<String> resources) async {
          //   return PermissionRequestResponse(
          //       resources: resources,
          //       action: PermissionRequestResponseAction.GRANT);
          // },
          clearCache: true,
          url: "http://volvere.in/aarvicollaborator",

          initialChild: WillPopScope(
              child: Center(),
              onWillPop: () {
                webView.dispose();
                return Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => ExitPage()),
                    (route) => false);
              }),
        ),
      ),
    );
    // onWillPop: () {
    //   return Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(builder: (context) => ExitPage()),
    //       (route) => false);
    //   return showDialog(
    //       context: context,
    //       barrierDismissible: false,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(15)),
    //           title: Text(
    //             "Confirm Exit",
    //             style: TextStyle(
    //                 fontFamily: "Montserrat", fontWeight: FontWeight.bold),
    //           ),
    //           content: Text(
    //             "Are you sure you want to exit?",
    //             style: TextStyle(
    //                 fontFamily: "Montserrat", fontWeight: FontWeight.w600),
    //           ),
    //           actions: <Widget>[
    //             FlatButton(
    //               child: Text(
    //                 "YES",
    //                 style: TextStyle(color: Colors.red),
    //               ),
    //               onPressed: () {
    //                 SystemNavigator.pop();
    //               },
    //             ),
    //             FlatButton(
    //               child: Text(
    //                 "NO",
    //                 style: TextStyle(color: Colors.black),
    //               ),
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //             )
    //           ],
    //         );
    //       });
    // });
  }
}
