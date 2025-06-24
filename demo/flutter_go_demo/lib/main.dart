import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

typedef _HelloFunc = Pointer<Utf8> Function();

typedef HelloFunc = Pointer<Utf8> Function();

class GoBinding {
  GoBinding() {
    final libName = Platform.isWindows
        ? 'hello.dll'
        : Platform.isMacOS
            ? 'libhello.dylib'
            : 'libhello.so';
    _lib = DynamicLibrary.open(libName);
    _hello = _lib
        .lookup<NativeFunction<_HelloFunc>>('HelloFromGo')
        .asFunction<HelloFunc>();
  }

  late final DynamicLibrary _lib;
  late final HelloFunc _hello;

  String greet() {
    final ptr = _hello();
    final str = ptr.toDartString();
    malloc.free(ptr);
    return str;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final go = GoBinding();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter + Go')),
        body: Center(child: Text(go.greet())),
      ),
    );
  }
}
