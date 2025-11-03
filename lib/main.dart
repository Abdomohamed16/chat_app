import 'package:chatapp/cubit/autho_cubit/autho_cubit.dart';
import 'package:chatapp/screens/Login_page.dart';
import 'package:chatapp/screens/homepage.dart';
import 'package:chatapp/screens/sighnup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});  

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: ThemeData.dark(),

        initialRoute: "/home",

        routes: {
          "/login": (_) => const LoginPage(),
          "/signup": (_) => const SignUpPage(),
          "/home": (_) => const HomePage(),
        },
      ),
    );
  }
}
