import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saathi/Screens/login/googlesignin.dart';
import 'package:saathi/Screens/personal.dart';
import 'package:saathi/Screens/shared.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () async {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text(
                        'Do you want to exit the app ?',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'No');
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context, 'Yes');
                            final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false,
                            );
                            // showDialog(
                            //   context: context,
                            //   builder: (context) => const Center(
                            //       child: CircularProgressIndicator()),
                            // );
                            await provider.logout(context);
                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('User succesfully logged out.'),
                              ),
                            );
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.logout_outlined,
              ),
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 50,
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(2, 3),
                          blurRadius: 4,
                          color: Color.fromARGB(255, 89, 89, 89),
                        )
                      ]),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.checklist_outlined),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ChecklistScreen(),
                        ),
                      );
                    },
                    label: const Text('Personal Checklist'),
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 50,
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(2, 3),
                          blurRadius: 4,
                          color: Color.fromARGB(255, 89, 89, 89),
                        )
                      ]),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.checklist_outlined),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SharedList(),
                        ),
                      );
                    },
                    label: const Text('Shared Checklist'),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
