import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_template/features/home/view/home_page.dart';
import 'package:flutter_template/features/auth/view/sign_in_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/features/auth/cubit/auth_cubit.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {

  @override
  void initState() {
    super.initState();
    // Firebase is initialized in bootstrap.
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.unknown || state.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.status == AuthStatus.unauthenticated) {
          return const SignInPage();
        }
        return const HomePage();
      },
    );
  }
}
