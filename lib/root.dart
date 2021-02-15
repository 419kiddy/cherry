import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cherry/main.dart';

class RootWidget extends HookWidget {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String _name = useProvider(nameProvider).state;
    final bool _cherry = useProvider(cherryProvider).state;
    String _addName = '';
    bool _addCherry = true;
    String _text = "";
    String UID = "";
    if (_cherry) {
      _text = "童貞";
    } else {
      _text = "";
    }

    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      print(auth.currentUser.uid);
      UID = auth.currentUser.uid;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Who's Cherry?"),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            child: Text(UID + "でログイン中"),
          ),
          Container(
            height: 50,
            child: Center(child: Text(_name)),
          ),
          Container(
            height: 50,
            child: Center(
                child: Text(
                  _text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),)),
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
                  FlatButton(
                    child: Text('cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                      child: Text('not cherry'),
                      onPressed: () {
                        if (_textController.text == '') {
                          Navigator.pop(context);
                        } else {
                          _addName = _textController.text;
                          _addCherry = false;
                          FirebaseFirestore.instance
                              .collection('boys')
                              .add({
                            'name': _addName,
                            'isCherry': _addCherry,
                          })
                              .then((value) => print("User Added"))
                              .catchError((error) =>
                              print("Failed to add user: $error"));
                          _textController.text = '';
                          Navigator.pop(context);
                        }
                      }),
                  FlatButton(
                      child: Text('cherry'),
                      onPressed: () {
                        if (_textController.text == '') {
                          Navigator.pop(context);
                        } else {
                          _addName = _textController.text;
                          _addCherry = true;
                          FirebaseFirestore.instance
                              .collection('boys')
                              .add({
                            'name': _addName,
                            'isCherry': _addCherry,
                          })
                              .then((value) => print("User Added"))
                              .catchError((error) =>
                              print("Failed to add user: $error"));
                          _textController.text = '';
                          Navigator.pop(context);
                        }
                      }),
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