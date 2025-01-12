import 'package:firebase/screens/authentication/register.dart';
import 'package:firebase/screens/authentication/sign_in.dart';
import 'package:firebase/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class Easyway extends StatefulWidget {
  const Easyway({super.key});

  @override
  State<Easyway> createState() => _EasywayState();
}

class _EasywayState extends State<Easyway>  with WidgetsBindingObserver{

  GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'Global Navigator');
    bool _hasCheckedAuthState = false;
    User? currentUser;

    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FirebaseAuth.instance.currentUser?.reload();
    if (!_hasCheckedAuthState) {
      _hasCheckedAuthState = true; // Prevent future invocations
      FirebaseAuth.instance.authStateChanges().first.then((user) {
        currentUser = user;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _routeUserForAuth(user);
        });
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    var app = MaterialApp(
      navigatorKey: globalNavigatorKey,
      onGenerateRoute: getPageRouteSettings(),
      debugShowCheckedModeBanner: false,

    );
    return app;
  }

  MaterialPageRoute Function(RouteSettings settings) getPageRouteSettings() {
    return (RouteSettings settings) {
      return MaterialPageRoute(
        builder: (context) => _getPageRoutes(context, settings),
      );
    };
  }

  _getPageRoutes(BuildContext context, RouteSettings settings) {
    dev.log('Navigating to: ${settings.name}');
    switch (settings.name) {
      case '/login':
        return  SignIn();
      case '/signup':
        return  Register();
      case '/home':
        return const Home();
      default:
        return  SignIn();
    }
  }
  
  void _routeUserForAuth(User? user) {
    if (user != null) {
        globalNavigatorKey.currentState!.pushReplacementNamed('/home');
      } else {
        globalNavigatorKey.currentState!.pushReplacementNamed('/login');
      }
  }
} 

//flutter local notification