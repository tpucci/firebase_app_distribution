# firebase_app_distribution

This Flutter plugin detects new versions of an app host on Firebase App Distribution.

## Usage

```dart
/// Checks if a new release is available and prompts the user to update
/// if there is one.
updateIfNewReleaseAvailable()
```

## Contribute

- [ ] Fork the repo
- [ ] Push some changes to your fork
- [ ] In **your own app**, in the `pubspec.yaml` file, point to your fork like this:

```yaml
dependencies:
  ...
  firebase_app_distribution:
    git:
      ref: main
      url: https://github.com/YOUR_GITHUB/firebase_app_distribution.git
```

- [ ] Test your contribution in **your** app
- [ ] Open a pull request with a recording of your test 🙏
