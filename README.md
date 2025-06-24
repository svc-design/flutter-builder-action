# Flutter Builder Action

This GitHub Action builds a Flutter project for multiple platforms.

## Inputs

- `platform`: Target platform (`linux`, `windows`, `macos`, `android`, `ios`).
- `arch`: Target architecture (default `x64`).

## Usage

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: your-org/flutter-builder-action@v1
        with:
          platform: linux
          arch: x64
```
