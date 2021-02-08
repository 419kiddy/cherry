import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

final nameProvider = StateProvider((ref) => "find cherry");
final cherryProvider = StateProvider((ref) => true);

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
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
            home: RootWidget(),
          );
        }

        // Firebaseのinitializeが完了するのを待つ間に表示するWidget
        return CircularProgressIndicator();
      },
    );
  }
}

class RootWidget extends HookWidget{
  @override
  Widget build(BuildContext context) {
    final String _name = useProvider(nameProvider).state;
    final bool _cherry = useProvider(cherryProvider).state;
    String _text = "";
    if (_cherry) {
      _text = "童貞";
    } else {_text = "";}
    return Scaffold(
      appBar: AppBar(title: Text("Who's Cherry?"),),
      body: Column(
        children: [
          Container(
            height: 50,
            child: Center(child: Text(_name)),
          ),
          Container(
            height: 50,
            child: Center(child: Text(_text)),
          ),
          Flexible(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('boys').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(snapshot.data == null) return CircularProgressIndicator();
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data.docs[index].data()['name']),
                      onTap: () async {
                        context
                            .read(nameProvider)
                            .state = snapshot.data.docs[index].data()["name"];
                        context
                            .read(cherryProvider)
                            .state = await snapshot.data.docs[index].data()["isCherry"];
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
    );
  }
}