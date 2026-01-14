import 'package:flutter/material.dart';
import 'package:frontend/app.dart';
import 'package:frontend/store/auth_store.dart';
import 'package:frontend/store/page/user/profil_store.dart';
import 'package:frontend/store/page/workout/workout_store.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthStore()),
        ChangeNotifierProvider(
          create: (context) =>
              ProfileStore(authStore: context.read<AuthStore>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              WorkoutStore(authStore: context.read<AuthStore>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Training App',
      theme: ThemeData.dark(),
      home: const App(),
    );
  }
}
