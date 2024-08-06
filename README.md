## flutter_dot_json_env

[![Pub Version][pub-badge]][pub]

[pub]: https://pub.dev/packages/flutter_dot_json_env
[pub-badge]: https://img.shields.io/pub/v/flutter_dot_json_env.svg

Load the configuration at runtime from a `local.json` file, making it accessible throughout the application.

# About

This library is a fork of [java-james/flutter_dotenv] Dart library, initially modified to ensure compatibility with Flutter.

[java-james/flutter_dotenv]: https://pub.dev/packages/flutter_dotenv

An _environment_ comprises variables recognized by a process (such as `PATH`, `PORT`, etc.). During development (including testing and staging, etc.), it is beneficial to replicate the production environment by reading these values from a file.

This library parses the file and integrates its values with the built-in [`Platform.environment`][docs-io] map.

[docs-io]: https://api.dart.dev/stable/3.4.4/dart-io/Platform-class.html#id_environment

# Usage

1.In the root directory of your project, create a file named local.json with the following example content:

```json
{
  "api_url": "https://api.local.dev.com",
  "foo": "foo",
  "bar": "bar"
}
```

2.Add the local.json file to your assets bundle in pubspec.yaml. Make sure the path matches the location of the local.json file!

```yml
assets:
  - local.json
```

3. Load the `local.json` file in `main.dart`.

```dart
import 'package:flutter_dot_json_env/flutter_dot_json_env.dart';

Future main() async {
  await dotjsonenv.load(fileName: "local.json");
  //...runapp
}
```

4.Access Object key value from `local.json` throughout the application

```dart
import 'package:flutter_dot_json_env/flutter_dot_json_env.dart';

String varibale_name = dotjsonenv.env['key_value'] ?? 'default fallback value';

```

# Useing `--dart-define` to select the environtment JSON file

1.Create a file named `[envFileName].json` with the same object keys as shown in the following example content:

```json
{
  "api_url": "https://api.local.dev.com",
  "foo": "foo",
  "bar": "bar"
}
```

2.Add the environment `JSON` file to your assets bundle in pubspec.yaml. Make sure the path matches the location of the local.json file!

```yml
assets:
  - assets/env/local.json
  - assets/env/dev.json
  - assets/env/test.json
  - assets/env/prelive.json
  - assets/env/live.json
```

3.Create new class for example `Environment`

```dart
class Environment {
  static const env = String.fromEnvironment('ENV');

  String get envFileName {
    switch (env) {
      case 'dev': // flutter run --dart-define=ENV=dev
        return 'assets/env/dev.json';
      case 'test': // flutter run --dart-define=ENV=test
        return 'assets/env/test.json';
      case 'prelive': // flutter run --dart-define=ENV=prelive
        return 'assets/env/prelive.json';
      case 'live': // flutter run --dart-define=ENV=live
        return 'assets/env/live.json';
      default: // flutter run
        return 'assets/env/local.json';
    }
  }

  static String get environmentName {
    return env.isNotEmpty ? env : "Environment name not found";
  }

  static String get apiUrl =>
      dotjsonenv.get('api_url', fallback: 'api url default fallback value');
  static String get foo =>
      dotjsonenv.env['foo'] ?? 'foo default fallback value';
  static String get bar =>
      dotjsonenv.env['bar'] ?? 'bar default fallback value';
}

```

4.Access value from `Environment` throughout the application

```dart
Future main() async {
  // await dotjsonenv.load(fileName: "assets/env/local.json"); // load as static json
  await dotjsonenv.load(fileName: Environment().envFileName);
  print('appURL::: ${Environment.apiUrl}'); // appURL::: https://api.local.com
  print('Foo::: ${Environment.foo}'); // Foo::: prelive foo
  print('Bar::: ${Environment.bar}'); // Bar::: prelive bar
//...runapp
}
```

5. To run the app or while taking build

```dart
 flutter run --dart-define=ENV=<envFileName>
 // flutter run --dart-define=ENV=dev
 flutter build web --dart-define=ENV=<envFileName>
 // flutter build web --dart-define=ENV=dev
```

# Null safety

To avoid null-safety checks for variables that are known to exist, there is a `get()` method that
will throw an exception if the variable is undefined. You can also specify a default fallback
value for when the variable is undefined in the .env file.

```dart
Future<void> main() async {
   await dotjsonenv.load(fileName: "local.json");

  String foo = dotjsonenv.get('key_value');

  // Or with fallback.
  String bar = dotjsonenv.get('missing_key_value', fallback: 'default fallback value');

  // This would return null.
  String? baz = dotenv.maybeGet('missing_key_value', fallback: null);
}
```

# Discussion

Use the [issue tracker][tracker] for bug reports and feature requests.

Pull requests are welcome.

[tracker]: https://github.com/govarthananve/flutter_dot_json_env/issues

# Prior art

[flutter_dot_json_env]: https://pub.dev/packages/flutter_dot_json_env

- [java-james/flutter_dotenv][] (dart)

# license: [MIT](LICENSE)
