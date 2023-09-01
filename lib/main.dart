import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'package:http/http.dart';
import 'screens/Users.dart';
import 'screens/configure.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Users CRUD',
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/login': (context) => const Login(),
      },
    );
  }
}

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String accountName = "N/N";
    String accountEmail = "N/A";
    String accountUrl =
        "https://images.unsplash.com/photo-1693040516624-a22f0906faab?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1374&q=80";

    Users user = Configure.login;
    if (user.id != null) {
      accountName = user.fullname!;
      accountEmail = user.email!;
    }

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(accountName),
            accountEmail: Text(accountEmail),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(accountUrl),
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            leading: Icon(
                Icons.login), // Corrected the icon name to lowercase 'login'
            title: Text("Login"),
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
