import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/setup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zpbfvdxaxwvynlnmcpsn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpwYmZ2ZHhheHd2eW5sbm1jcHNuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzEzMjg3NjksImV4cCI6MjA4NjkwNDc2OX0.FLAMtCkLRngFt9N4DF03F3H4ILuNv15sGiVnK9MRBYA',
  );

  runApp(const LayoverFriendsApp());
}

class LayoverFriendsApp extends StatelessWidget {
  const LayoverFriendsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SetupScreen(),
    );
  }
}
