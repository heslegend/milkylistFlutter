import 'package:flutter/material.dart';
import 'package:milkylist/repository/user_repository.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextStyle styleHeading = TextStyle(fontFamily: 'Montserrat', fontSize: 24.0);
  TextEditingController _email;
  TextEditingController _password;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final userRepository = Provider.of<UserRepository>(context);
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        key: _key,
        body: Form(
          key: _formKey,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                welcomeText(),
                milkIcon(),
                signUpOrSignInText(),
                emailFormField(),
                passwordFormField(),
                userRepository.status == Status.Authenticating
                    ? Center(child: CircularProgressIndicator())
                    : signInButton(userRepository),
                userRepository.status == Status.Registering
                    ? Center(child: CircularProgressIndicator())
                    : signUpButton(userRepository)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding milkIcon() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Icon(
        Icons.local_drink,
        color: Colors.blue,
        size: 48.0,
      ),
    );
  }

  Padding welcomeText() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Welcome to milkylist!",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline,
        ));
  }

  Padding signUpOrSignInText() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          " Please sign up or sign in",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title,
        ));
  }

  Padding passwordFormField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12.0)),
        child: TextFormField(
          controller: _password,
          validator: (value) =>
              (value.isEmpty) ? "   Please Enter Password" : null,
          style: Theme.of(context).textTheme.body1,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              labelText: "Password",
              border: InputBorder.none),
        ),
      ),
    );
  }

  Padding emailFormField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12.0)),
        child: TextFormField(
            controller: _email,
            validator: (value) => (value.isEmpty) ? "Please Enter Email" : null,
            style: Theme.of(context).textTheme.body1,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              labelText: "Email",
              border: InputBorder.none,
            )),
      ),
    );
  }

  Padding signInButton(UserRepository userRepository) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Theme.of(context).cardColor,
        child: MaterialButton(
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              if (!await userRepository.signIn(
                  _email.text.trim(), _password.text))
                _key.currentState.showSnackBar(SnackBar(
                  content: Text("Something is wrong"),
                ));
            } else {
              _key.currentState.showSnackBar(SnackBar(
                content: Text("Sucessfully signed in."),
              ));
            }
          },
          splashColor: Colors.blue,
          child: Text(
            "Sign In",
            style: Theme.of(context).textTheme.body2,
          ),
        ),
      ),
    );
  }

  Padding signUpButton(UserRepository userRepository) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Theme.of(context).cardColor,
        child: MaterialButton(
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              String result = await userRepository.signUp(
                  _email.text.trim(), _password.text);
              _key.currentState.showSnackBar(SnackBar(
                content: Text(result),
              ));
            }
          },
          splashColor: Colors.blue,
          child: Text(
            "Sign Up",
            style: Theme.of(context).textTheme.body2.copyWith(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
