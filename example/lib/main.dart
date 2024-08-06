import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dot_json_env/flutter_dot_json_env.dart';

Future main() async {
  // await dotjsonenv.load(fileName: "assets/env/local.json"); // load as static json
  await dotjsonenv.load(fileName: Environment().envFileName);

  print(
      'app URL::: ${dotjsonenv.env['api_url'] ?? 'api url default fallback value'}');
  print('appURL::: ${Environment.apiUrl}');
  print('Foo::: ${Environment.foo}');
  print('Bar::: ${Environment.bar}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('DotJSONEnv Demo'),
          backgroundColor: Colors.teal,
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<String>(
            future: rootBundle.loadString('assets/env/local.json'),
            initialData: '',
            builder: (context, snapshot) => Container(
              padding: const EdgeInsets.all(50),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Env map: ${dotjsonenv.env.toString()}',
                    ),
                    Text(dotjsonenv.get('api_url',
                        fallback: 'api url default fallback value')),
                    Text(dotjsonenv.get('foo',
                        fallback: 'foo default fallback value')),
                    Text(dotjsonenv.get('bar',
                        fallback: 'bar default fallback value')),
                    const Text("Environment class values"),
                    Text('appURL::: ${Environment.apiUrl}'),
                    Text('Foo::: ${Environment.foo}'),
                    Text('Bar::: ${Environment.bar}'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
