import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'views/debts_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // Define the default App theme.
          brightness: Brightness.dark,
          primaryColor: Colors.white60,
          // Define the default Text theme.
          fontFamily: 'Georgia',
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontSize: 30.0, fontStyle: FontStyle.italic),
            bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
          // Define the default Button theme.
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white60))),
        ),
        home: FutureBuilder(
            future: _initialization,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                    child: Text('Beklenilmeyen Bir Hata Oluştur'));
              } else if (snapshot.hasData) {
                return const DebtsView();
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
