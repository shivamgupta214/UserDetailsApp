import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String name, address, dob, state;
  Color mainColor;
  HomePage(
      {Key key,
      @required this.name,
      this.address,
      this.dob,
      this.mainColor,
      this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[400],
      appBar: AppBar(
        title: Text('Profile Information'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Form(
            child: Card(
          color: mainColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(50)),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(name),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text(address),
              ),
              ListTile(
                leading: Icon(Icons.date_range),
                title: Text(dob),
              ),
              ListTile(
                leading: Icon(Icons.add_to_queue),
                title: Text(state),
              ),
              Padding(padding: EdgeInsets.all(100))
            ],
          ),
        )),
      ),
    );
  }
}
