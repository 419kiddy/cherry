import 'package:cherry/main.dart';
import 'package:cherry/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/all.dart';
import 'signup_model.dart';

final alertProvider = StateProvider((ref) => "");

class SignUpPage extends HookWidget{
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build (BuildContext context) {
    final String _alert = useProvider(alertProvider).state;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Center(
        child: Column(
            children: [
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: "your E-mail address",
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: "password",
                ),
                obscureText: true,
              ),
              Text(_alert, style: TextStyle(color: Colors.red),),
              TextButton(
                child: Text('Sign Up'),
                onPressed: () async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: _addressController.text,
                        password: _passwordController.text
                    );
                    _addressController.text = "";
                    _passwordController.text = "";
                    context.read(stateProvider).state = 2;

                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      context.read(alertProvider).state = "安全性が低いパスワードです。";
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      context.read(alertProvider).state = "既に使用されているメールアドレスです。";
                      print('The account already exists for that email.');
                    }
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              TextButton(
                  onPressed: (){
                    context.read(stateProvider).state = 1;
                  },
                  child: Text("アカウントをお持ちですか？"),
              )
            ],
          ),
      ),
    );
  }
}