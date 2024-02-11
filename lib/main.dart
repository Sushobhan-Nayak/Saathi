import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saathi/Screens/homepage.dart';
import 'package:saathi/Screens/loading.dart';
import 'package:saathi/Screens/login/login.dart';
import 'package:saathi/Theme/theme.dart';
import 'package:saathi/firebase_options.dart';
import 'package:saathi/Screens/login/googlesignin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  final googleSignInProvider = GoogleSignInProvider();
  await googleSignInProvider.initSharedPreferences();
  runApp(MyApp(googleSignInProvider: googleSignInProvider));
}

class MyApp extends StatelessWidget {
  final GoogleSignInProvider googleSignInProvider;
  const MyApp({required this.googleSignInProvider, super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
        value: googleSignInProvider,
        child: MaterialApp(
          theme: appTheme,
          debugShowCheckedModeBanner: false,
          home: const MyHomePage(),
        ),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        } else if (snapshot.hasData) {
          return const HomePage();
        } else if (snapshot.hasError) {
          return const Center(child: Text('Something has gone wrong.'));
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
