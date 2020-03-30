import 'package:flutter/material.dart';
import 'package:milkylist/home_page.dart';
import 'package:milkylist/repository/user_repository.dart';
import 'package:milkylist/authentication_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserRepository.instance(),
      child: Theme(
        data: ThemeData(
            primaryColor: Colors.white,
            accentColor: Colors.cyanAccent,
            cardColor: Color.fromRGBO(69, 80, 96, 100),
            backgroundColor: Color.fromRGBO(61, 72, 84, 100),
            fontFamily: 'Monteserrat',
            textTheme: TextTheme(
                headline: TextStyle(
                    fontSize: 52.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                title: TextStyle(
                    fontSize: 26.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.white),
                body1: TextStyle(fontSize: 14.0, color: Colors.blue),
                body2: TextStyle(fontSize: 18.0, color: Colors.white))),
        child: Consumer(
          builder: (context, UserRepository userRepository, _) {
            switch (userRepository.status) {
              case Status.Uninitialized:
                return LoginPage();
              case Status.Unauthenticated:
                return LoginPage();
              case Status.Authenticating:
                return LoginPage();
              case Status.Authenticated:
                return HomePage(userRepository: userRepository);
              case Status.Registering:
                return LoginPage();
              case Status.Registered:
                return LoginPage();
              default:
                return LoginPage();
            }
          },
        ),
      ),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Center(
            child: CircularProgressIndicator(
                backgroundColor: Colors.teal, strokeWidth: 5.0),
          ),
          Center(
            child: Text("Please wait a moment.."),
          ),
        ],
      ),
    );
  }
}
