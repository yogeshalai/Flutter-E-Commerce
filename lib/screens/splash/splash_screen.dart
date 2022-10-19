import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) {
        return previous.authUser != current.authUser ||
            current.authUser == null;
      },
      listener: (context, state) {
        print('Splash screen listener: $state');
        Timer(
          const Duration(seconds: 1),
          () => Navigator.pushNamed(context, '/'),
        );
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Image(
                image: AssetImage('assets/images/logo.png'),
                width: 125,
                height: 125,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: Text(
                'Zero To Unicorn',
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      color: Colors.white,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
