# Flutter Builder Action

This GitHub Action builds a Flutter project for multiple platforms. It sets up Flutter on the runner, installs dependencies, and runs the appropriate build command for the selected platform.

## Inputs

- `platform`: Target platform (`linux`, `windows`, `macos`, `android`, `ios`).
- `arch`: Target architecture. Defaults to `x64` if omitted.

## Basic Usage

Create a workflow using this action to build your Flutter project. Below is an example targeting Linux on `x64`:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: svc-design/flutter-multi-platform-builder@v0.1.1
        with:
          platform: linux
          arch: x64
```

## Building for Multiple Platforms

You can use a build matrix to build for multiple platforms in one workflow:

```yaml
jobs:
  build:
    strategy:
      matrix:
        platform: [linux, windows, macos, android, ios]
    runs-on: ${{ matrix.platform == 'windows' && 'windows-latest' || matrix.platform == 'macos' && 'macos-latest' || 'ubuntu-latest' }}
    steps:
      - uses: actions/checkout@v4
      - uses: svc-design/flutter-multi-platform-builder@v0.1.1
        with:
          platform: ${{ matrix.platform }}
```

## 📦 Supported Outputs

| Platform | Artifact Output                          |
|----------|------------------------------------------|
| Android  | `build/app/outputs/flutter-apk/app-release.apk` |
| iOS      | `build/ios/ipa/*.ipa`, `.app.zip`        |
| macOS    | `.dmg` file                              |
| Windows  | `.zip`, `.msix`                          |
| Linux    | `.AppImage`, `.zip`                      |

## 🧩 Inputs

| Name      | Required | Description                                    | Default |
|-----------|----------|------------------------------------------------|---------|
| `platform`| ✅        | Target platform (linux, windows, macos...)     | —       |
| `arch`    | ❌        | Target architecture (x64, arm64)               | x64     |

## 🚀 Output

None yet — add output in future versions if needed.

# Example: Flutter + Go Demo

This repository contains a simple cross-platform demo located in [`demo/`](demo/). The demo shows how to call a Go library from Flutter using FFI. The Go code exports a single `HelloFromGo` function. A minimal Flutter app loads the compiled library and displays the returned string.

### Go Library

`demo/go/hello.go`:

```go
package main

import "C"

//export HelloFromGo
func HelloFromGo() *C.char {
    return C.CString("Hello from Go")
}

func main() {}
```

The accompanying `build.sh` script builds the library for all supported platforms using cross compilation.

### Flutter App

`demo/flutter_go_demo/lib/main.dart`:

```dart
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
```

### Building the Demo

With the Go library built for the desired platform, you can run the action to build the Flutter app. For example, to build for Linux:

```yaml
jobs:
  build-demo:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: your-org/flutter-builder-action@v1
        with:
          platform: linux
```

The resulting artifacts can then be downloaded from the workflow run.

---

This action simplifies building Flutter projects in CI by handling setup and platform-specific commands. Use it to build applications – including the provided Flutter + Go demo – for all major platforms.
