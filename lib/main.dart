import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

final nameProvider = StateProvider((ref) => "Let's find");
final cherryProvider = StateProvider((ref) => true);
final addNameProvider = StateProvider((ref) => "");
final addCherryProvider = StateProvider((ref) => true);


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

class RootWidget extends HookWidget {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String _name = useProvider(nameProvider).state;
    final bool _cherry = useProvider(cherryProvider).state;
    final String _addName = useProvider(addNameProvider).state;

    final bool _addCherry = useProvider(addCherryProvider).state;
    String _text = "";
    if (_cherry) {
      _text = "童貞";
    } else {
      _text = "";
    }
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Who's Cherry?"),
      ),
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
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data == null) return CircularProgressIndicator();
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data.docs[index].data()['name']),
                      onTap: () async {
                        context.read(nameProvider).state =
                            snapshot.data.docs[index].data()["name"];
                        context.read(cherryProvider).state =
                            await snapshot.data.docs[index].data()["isCherry"];
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
        child: Icon(Icons.add),
        onPressed: () async {
          // ダイアログを表示------------------------------------
          var result = await showDialog<int>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("registration"),
                content: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: "name",
                  ),
                  autofocus: true,
                ),
                actions: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text('cherry:'),
                          Radio(
                              activeColor: Colors.blue,
                              value: true,
                              groupValue: _addCherry,
                              onChanged: (bool){context.read(addCherryProvider).state = true;},
                          ),
                          Text('    not cherry:'),
                          Radio(
                              activeColor: Colors.blue,
                              value: false,
                              groupValue: _addCherry,
                              onChanged: (bool){context.read(addCherryProvider).state = false;},
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          FlatButton(
                            child: Text(localizations.cancelButtonLabel),
                            onPressed: () => Navigator.pop(context),
                          ),
                          FlatButton(
                            child: Text(localizations.okButtonLabel),
                            onPressed: () {
                              context.read(addNameProvider).state = _textController.text;
                              _textController.text = '';
                              Navigator.pop(context);
                            }
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          );
          // --
        },
      ),
    );
  }
}
