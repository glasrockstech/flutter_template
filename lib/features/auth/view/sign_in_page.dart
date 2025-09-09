import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_template/l10n/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/features/auth/cubit/auth_cubit.dart';
import 'package:flutter_template/repositories/auth_repository.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.emailRequiredMessage)),
      );
      return;
    }
    if (password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.passwordRequiredMessage)),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().clearError();
    try {
      await context.read<AuthCubit>().signIn(
            email,
            password,
          );
    } catch (e, st) {
      log('Sign-in error (unexpected): $e', stackTrace: st);
    } finally {
      // Loading state handled by cubit
    }
  }

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.emailRequiredMessage)),
      );
      return;
    }
    if (password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.passwordRequiredMessage)),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().clearError();
    try {
      await context.read<AuthCubit>().signUp(
            email,
            password,
          );
    } catch (e, st) {
      log('Sign-up error (unexpected): $e', stackTrace: st);
    } finally {
      // Loading state handled by cubit
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.emailRequiredMessage)),
      );
      return;
    }
    try {
      await context.read<AuthCubit>().resetPassword(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.resetEmailSent)),
      );
    } catch (e, st) {
      log('Reset password error: $e', stackTrace: st);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.genericErrorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final loading = state.loading;
        final failure = state.error;
        final errorMessage = failure == null
            ? null
            : _failureToMessage(context, failure);
        return Scaffold(
          appBar: AppBar(title: Text(l10n.signInTitle)),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App icon at the top of the sign-in page
                  Center(
                    child: CircleAvatar(
                      radius: 56,
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        'assets/app_icon.png',
                        width: 88,
                        height: 88,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (errorMessage != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        errorMessage,
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: l10n.emailLabel),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      final value = (v ?? '').trim();
                      if (value.isEmpty) return l10n.emailRequiredMessage;
                      if (!value.contains('@') || !value.contains('.')) {
                        return l10n.invalidEmailMessage;
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: l10n.passwordLabel,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() => _obscure = !_obscure);
                        },
                      ),
                    ),
                    obscureText: _obscure,
                    textInputAction: TextInputAction.done,
                    validator: (v) => (v == null || v.isEmpty)
                        ? l10n.passwordRequiredMessage
                        : null,
                    onFieldSubmitted: (_) => _signIn(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: loading ? null : _signIn,
                          child: loading
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(l10n.signInButton),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: loading ? null : _signUp,
                          child: Text(l10n.signUpButton),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: loading ? null : _forgotPassword,
                      child: Text(l10n.forgotPasswordButton),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

String _failureToMessage(BuildContext context, AuthFailure failure) {
  final l10n = context.l10n;
  switch (failure) {
    case AuthFailure.invalidEmail:
      return l10n.invalidEmailMessage;
    case AuthFailure.userDisabled:
      return l10n.genericErrorMessage;
    case AuthFailure.userNotFound:
      return l10n.userNotFoundMessage;
    case AuthFailure.wrongPassword:
      return l10n.wrongPasswordMessage;
    case AuthFailure.tooManyRequests:
      return l10n.tooManyRequestsMessage;
    case AuthFailure.weakPassword:
      return l10n.weakPasswordMessage;
    case AuthFailure.emailAlreadyInUse:
      return l10n.emailInUseMessage;
    case AuthFailure.requiresRecentLogin:
      return l10n.requiresRecentLoginMessage;
    case AuthFailure.network:
      return l10n.networkErrorMessage;
    case AuthFailure.unknown:
      return l10n.genericErrorMessage;
  }
}
