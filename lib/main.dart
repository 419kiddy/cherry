import 'package:cherry/signin/signin_page.dart';
import 'package:cherry/signup/signup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cherry/root.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

final nameProvider = StateProvider((ref) => "Let's find");
final cherryProvider = StateProvider((ref) => true);
final stateProvider = StateProvider((ref) => 0);
//0 signup
//1 signin
//2 root

class MyApp extends HookWidget {
  var _routes = [
    SignUpPage(),
    SignInPage(),
    RootWidget(),
  ];
  @override
  Widget build(BuildContext context) {
    final int _state = useProvider(stateProvider).state;
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // エラー時に表示するWidget
        if (snapshot.hasError) {
          return Container(color: Colors.white);
        }

        // Firebaseのinitialize完了したら表示したいWidget
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: "Who's Cherry?",
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: _routes[_state],
          );
        }

        // Firebaseのinitializeが完了するのを待つ間に表示するWidget
        return CircularProgressIndicator();
      },
    );
  }
}


