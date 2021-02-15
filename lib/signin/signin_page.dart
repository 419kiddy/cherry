import 'package:cherry/main.dart';
import 'package:cherry/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/all.dart';

final alertProvider = StateProvider((ref) => "");

class SignInPage extends HookWidget{
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build (BuildContext context) {
    final String _alert = useProvider(alertProvider).state;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
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
              child: Text('Sign In'),
              onPressed: () async {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _addressController.text,
                      password: _passwordController.text,
                  );
                  context.read(stateProvider).state = 2;

                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    context.read(alertProvider).state = "ご利用のメールアドレスは登録されていません。";
                    print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    context.read(alertProvider).state = "パスワードが間違っています。";
                    print('Wrong password provided for that user.');
                  }
                }
              },
            ),
            TextButton(
              onPressed: (){
                // context.read(stateProvider).state =
              },
              child: Text("パスワードを忘れましたか？"),
            )
          ],
        ),
      ),
    );
  }
}