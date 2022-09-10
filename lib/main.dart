import 'package:band_names/src/services/socket_service.dart';
import 'package:flutter/material.dart';

import 'package:band_names/src/pages/home.dart';
import 'package:band_names/src/pages/status.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => SocketService())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home': (context) => const HomePage(),
          'status': (context) => const StatusPage()
        },
      ),
    );
  }
}
