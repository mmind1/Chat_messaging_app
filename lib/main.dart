import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/models/user_data.dart';
import 'package:firebase_chat/screens/home_screen.dart';
import 'package:firebase_chat/screens/login_screen.dart';
import 'package:firebase_chat/services/auth_service.dart';
import 'package:firebase_chat/services/database_service.dart';
import 'package:firebase_chat/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserData(),
          ),
          Provider<AuthService>(
            create: (_) => AuthService(),
          ),
          Provider<DatabaseService>(
            create: (_) => DatabaseService(),
          ),
          Provider<StorageService>(
            create: (_) => StorageService(),
          ),
        ],
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: StreamBuilder<FirebaseUser>(
        stream: Provider.of<AuthService>(context, listen: false).user,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Provider.of<UserData>(context, listen: false).currentUserId =
                snapshot.data.uid;
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
