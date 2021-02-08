import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

final countProvider = StateProvider((ref) => 0);

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CounterApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RootWidget(),
    );
  }
}

class RootWidget extends HookWidget{
  @override
  Widget build(BuildContext context) {
    final int count = useProvider(countProvider).state;
    return Scaffold(
      appBar: AppBar(title: Text('CounterApp'),),
      body: Center(
        child: Text(count.toString()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          context.read(countProvider).state++;
        },
      ),
    );
  }
}