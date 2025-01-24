import 'dart:io';

import 'package:flutter/material.dart';

import '../components/inputs.dart';
import 'pickers/user_image.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String userName,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitAuthForm;
  final bool isLoading;

  const AuthForm(
      {required this.submitAuthForm, required this.isLoading, super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;

  late String _userEmail = '';
  late String _userName = '';
  late String _userPassword = '';

  late File _userImage = File('');

  void _pickedImage(File image) {
    _userImage = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImage.path.isEmpty && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please pick an image.',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();

      widget.submitAuthForm(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImage,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin)
                    UserImage(
                      imagePickFn: _pickedImage,
                    ),
                  const SizedBox(height: 10),
                  TextInput(
                      key: const ValueKey('email'),
                      autocorrection: false,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      labelText: 'E-Mail',
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) {
                        _userEmail = value!;
                      }),
                  const SizedBox(height: 10),
                  if (!_isLogin)
                    TextInput(
                      key: const ValueKey('username'),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter a valid username';
                        }
                        return null;
                      },
                      labelText: 'Username',
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  const SizedBox(height: 10),
                  TextInput(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long';
                      }
                      return null;
                    },
                    labelText: 'Password',
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  const SizedBox(height: 10),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Sign up'),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      child: Text(
                        _isLogin
                            ? 'Create new account'
                            : 'I have an existing account',
                      ),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
