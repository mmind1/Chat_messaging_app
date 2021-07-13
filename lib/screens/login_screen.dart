import 'package:firebase_chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();
  String _name, _email, _password;
  int _selectedIndex = 0;

  _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: <Widget>[
          _buildEmailTF(),
          _buildPasswordTF(),
        ],
      ),
    );
  }

  _buildSignupForm() {
    return Form(
      key: _signupFormKey,
      child: Column(
        children: <Widget>[
          _buildNameTF(),
          _buildEmailTF(),
          _buildPasswordTF(),
        ],
      ),
    );
  }

  _buildNameTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10.0,
      ),
      child: TextFormField(
        decoration: const InputDecoration(labelText: 'Name'),
        validator: (input) =>
            input.trim().isEmpty ? 'Please enter a name' : null,
        onSaved: (input) => _name = input.trim(),
      ),
    );
  }

  _buildEmailTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10.0,
      ),
      child: TextFormField(
        decoration: const InputDecoration(labelText: 'Email'),
        validator: (input) =>
            !input.contains('@') ? 'Please enter a valid email' : null,
        onSaved: (input) => _email = input,
      ),
    );
  }

  _buildPasswordTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10.0,
      ),
      child: TextFormField(
        decoration: const InputDecoration(labelText: 'Password'),
        validator: (input) =>
            input.length < 6 ? 'Must be at least 6 characters' : null,
        onSaved: (input) => _password = input,
        obscureText: true,
      ),
    );
  }

  _submit() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      if (_selectedIndex == 0 && _loginFormKey.currentState.validate()) {
        _loginFormKey.currentState.save();
        await authService.login(_email, _password);
      } else if (_selectedIndex == 1 &&
          _signupFormKey.currentState.validate()) {
        _signupFormKey.currentState.save();
        await authService.signup(_name, _email, _password);
      }
    } on PlatformException catch (err) {
      _showErrorDialog(err.message);
    }
  }

  _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 150.0,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: _selectedIndex == 0 ? Colors.blue : Colors.grey[300],
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: _selectedIndex == 0 ? Colors.white : Colors.blue,
                      ),
                    ),
                    onPressed: () => setState(() => _selectedIndex = 0),
                  ),
                ),
                Container(
                  width: 150.0,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: _selectedIndex == 1 ? Colors.blue : Colors.grey[300],
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: _selectedIndex == 1 ? Colors.white : Colors.blue,
                      ),
                    ),
                    onPressed: () => setState(() => _selectedIndex = 1),
                  ),
                ),
              ],
            ),
            _selectedIndex == 0 ? _buildLoginForm() : _buildSignupForm(),
            const SizedBox(height: 20.0),
            Container(
              width: 180.0,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.blue,
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
