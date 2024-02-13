import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saathi/Screens/login/googlesignin.dart';
import 'package:sign_button/sign_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.primary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            height: 50,
            child: SignInButton(
              buttonType: ButtonType.google,
              buttonSize: ButtonSize.medium,
              btnTextColor: Colors.black,
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const Center(child: CircularProgressIndicator());
                    });
                final provider = Provider.of<GoogleSignInProvider>(
                  context,
                  listen: false,
                );
                await provider.googleLogin();
                await provider.saveUser(provider.user);
                if (!mounted) return;
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
    );
  }
}
