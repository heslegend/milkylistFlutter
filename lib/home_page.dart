import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milkylist/repository/user_repository.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final _userRepository;

  HomePage({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to milkylist!"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget._userRepository.user.email),
            MaterialButton(
              color: Colors.teal,
              child: Text("LOG OUT"),
              onPressed: () =>
                  Provider.of<UserRepository>(context, listen: false).signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
