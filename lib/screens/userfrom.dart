
import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:login/screens/configure.dart';
import 'Users.dart';
import 'package:http/http.dart' as http;


class usersFrom extends StatefulWidget {
  const usersFrom({super.key});

  @override
  State<usersFrom> createState() => _usersFromState();
}

class _usersFromState extends State<usersFrom> {
  final _formkey = GlobalKey<FormState>();
  // Users user = Users();
  late Users user;

  Future<void> updateData (user) async{
    var url = Uri.http(Configure.server, "users/${user.id}");
    var resp = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()));
    var rs = usersFromJson("[${resp.body}]");
    if (rs.length == 1) {
      Navigator.pop(context, "refresh");
    }
    return;
  }



  
  Future<void> addNewUser (user) async{
    var url = Uri.http(Configure.server, "users");
    var resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()));
    var rs = usersFromJson("[${resp.body}]");

    if (rs.length == 1) {
      Navigator.pop(context, "refresh");
    }
    return;
  }
  
  @override
  Widget build(BuildContext context) {
    try {
      user = ModalRoute.of(context)!.settings.arguments as Users;
      print(user.fullname);
    } catch (e) {
      user = Users();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("User From"),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fnameInputField(),
              emailInputField(),
              passwordInputField(),
              genderFormInput(),
              SizedBox(
                height: 10, 
                ),
                submitButton(),
            ],
          ),
        ),
      ),
    );
  }


  Widget fnameInputField() {
    return TextFormField(
      initialValue: user.fullname,
      decoration: InputDecoration(
        labelText: "Fullname",
        icon: Icon(Icons.person)),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => user.fullname = newValue,
      ); 
  }

    Widget emailInputField() {
    return TextFormField(
      initialValue: user.email,
      decoration: InputDecoration(
        labelText: "Email",
        icon: Icon(Icons.email)),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => user.email = newValue,
      ); 
  }

    Widget passwordInputField() {
    return TextFormField(
      initialValue: user.password,
      decoration: InputDecoration(
        labelText: "password",
        icon: Icon(Icons.lock)),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => user.password = newValue,
      ); 
  }

  Widget genderFormInput() {
    var initGen = "None";
    try {
      if (!user.gender!.isNull) {
        initGen = user.gender!;
      }
    } catch (e) {
      initGen = "None";
    }

    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: "Gender:", icon: Icon(Icons.man)),
    value: initGen,
    items: Configure.gender.map((String val) {
      return DropdownMenuItem(
        value: val,
        child: Text(val),
      );
    }).toList(),
    onChanged: (value) {
      user.gender = value;
    },
    onSaved: (newValue) => user.gender);
  }

  Widget submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formkey.currentState!.validate()) {
          _formkey.currentState!.save();
          print(user.toJson().toString());
          if (user.id == null) {
            addNewUser(user);
          } else {
            updateData(user);
          }
        }
      },
    child: Text("Save"));
}
}





