import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dot_json_env/flutter_dot_json_env.dart';

Future main() async {
  await dotjsonenv.load(
      fileName:
          "assets/env/local.json"); // mergeWith optional, you can include Platform.environment for Mobile/Desktop app
  print(
      'app URL::: ${dotjsonenv.env['api_url'] ?? 'api url default fallback value'}');
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
