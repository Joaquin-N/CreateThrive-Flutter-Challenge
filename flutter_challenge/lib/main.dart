import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubits/app/app_cubit.dart';
import 'package:flutter_challenge/firebase_options.dart';
import 'package:flutter_challenge/pages/home_page.dart';
import 'package:flutter_challenge/pages/shopping_list_page.dart';
import 'package:flutter_challenge/routes.dart';
import 'package:flutter_challenge/services/firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Firestore.instance.fillData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Challenge',
      routes: {
        Routes.home: (_) => const HomePage(),
      },
      initialRoute: Routes.home,
    );
  }
}
