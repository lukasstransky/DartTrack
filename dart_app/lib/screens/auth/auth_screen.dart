import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

import '../../services/auth_service.dart';
import '../../constants.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _isLoading = false;
  bool _usernameValid = false;
  AuthMode _authMode = AuthMode.Login;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    _usernameValid = await context
        .read<AuthService>()
        .usernameValid(_usernameController.text);
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      late String msg;
      _emailController.text = _emailController.text.trim();

      if (_authMode == AuthMode.Login) {
        await context
            .read<AuthService>()
            .login(_emailController.text, _passwordController.text);

        msg = "Login Successfully!";
      } else {
        await context
            .read<AuthService>()
            .register(_emailController.text, _passwordController.text);

        await context.read<AuthService>().postUserToFirestore(
            _emailController.text, _usernameController.text);

        msg = "Account Created Successfully!";
      }

      Fluttertoast.showToast(msg: msg);
      Navigator.of(context).pushNamed('/home');
    } on FirebaseAuthException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('email-already-in-use')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('user-not-found')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('wrong-password')) {
        errorMessage = 'Invalid password.';
      } else if (error.toString().contains('too-many-requests')) {
        errorMessage =
            'To many failed attempts. Try again later or reset password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _emailController.text = '';
        _passwordController.text = '';
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _emailController.text = '';
        _passwordController.text = '';
        _usernameController.text = '';
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Container(
          //width: deviceSize.width,
          //height: deviceSize.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _authMode == AuthMode.Login ? 'LOGIN' : 'REGISTER',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (_authMode == AuthMode.Signup)
                SizedBox(
                  height: deviceSize.height * 0.01,
                ),
              if (_authMode == AuthMode.Signup)
                Container(
                  width: deviceSize.width * 0.8,
                  child: TextFormField(
                    autofocus: false,
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Username is Required!");
                      }
                      if (!_usernameValid) {
                        return ("Username already exists!");
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                      ),
                      hintText: "Username",
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: deviceSize.height * 0.01,
              ),
              Container(
                width: deviceSize.width * 0.8,
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Email is Required!");
                    }
                    /*if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return ("Please Enter a Valid Email");
                    }*/
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.mail,
                    ),
                    hintText: "Email",
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: deviceSize.height * 0.01,
              ),
              Container(
                width: deviceSize.width * 0.8,
                child: TextFormField(
                  obscureText: !_passwordVisible,
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Password is Required!");
                    }
                    /*if (!RegExp(
                            "^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}\$") //Minimum eight characters, at least one letter and one number
                        .hasMatch(value)) {
                      return ("Please Enter a Valid Password!");
                    }*/
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    hintText: "Password",
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                ),
              ),
              if (_authMode == AuthMode.Login)
                SizedBox(
                  height: deviceSize.height * 0.008,
                ),
              if (_authMode == AuthMode.Login)
                Container(
                  width: deviceSize.width * 0.8,
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushNamed('/forgotPassword'),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ),
              if (_isLoading)
                CircularProgressIndicator()
              else
                Container(
                  width: deviceSize.width * 0.6,
                  child: TextButton(
                    child: Text(
                      _authMode == AuthMode.Login ? 'LOGIN' : 'REGISTER',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () => _submit(),
                  ),
                ),
              SizedBox(
                height: deviceSize.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_authMode == AuthMode.Login
                      ? 'Don\'t have an account? '
                      : 'Already have an account? '),
                  GestureDetector(
                    onTap: () => _switchAuthMode(),
                    child: Text(
                      _authMode == AuthMode.Login ? 'Register' : 'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: deviceSize.height * 0.01,
              ),
              GestureDetector(
                onTap: () async =>
                    await context.read<AuthService>().loginAnonymously(),
                child: Text(
                  "Proceed as Guest",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
