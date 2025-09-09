import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/l10n/l10n.dart';
import 'package:flutter_template/features/auth/cubit/auth_cubit.dart';
import 'package:flutter_template/repositories/auth_repository.dart';
import 'package:flutter_template/theme/theme_controller.dart';
import 'package:flutter_template/theme/theme_controller_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final email = context.read<AuthCubit>().state.email;
    _emailController.text = email ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeCtrl = ThemeControllerProvider.of(context);
    final mode = themeCtrl.mode;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.themeSectionTitle,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          RadioListTile<ThemeMode>(
            title: Text(l10n.themeSystem),
            value: ThemeMode.system,
            groupValue: mode,
            onChanged: (m) => themeCtrl.setMode(ThemeMode.system),
          ),
          RadioListTile<ThemeMode>(
            title: Text(l10n.themeLight),
            value: ThemeMode.light,
            groupValue: mode,
            onChanged: (m) => themeCtrl.setMode(ThemeMode.light),
          ),
          RadioListTile<ThemeMode>(
            title: Text(l10n.themeDark),
            value: ThemeMode.dark,
            groupValue: mode,
            onChanged: (m) => themeCtrl.setMode(ThemeMode.dark),
          ),
          const Divider(height: 32),
          Text(l10n.accountSectionTitle,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: l10n.changeEmailLabel,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final email = _emailController.text.trim();
                    if (email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.emailRequiredMessage)),
                      );
                      return;
                    }
                    try {
                      await context.read<AuthRepository>().changeEmail(email);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.changeEmailSuccess)),
                      );
                    } on AuthFailure catch (f) {
                      if (!mounted) return;
                      final msg = _mapChangeEmailFailure(context, f);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(msg)));
                    } catch (_) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.genericErrorMessage)),
                      );
                    }
                  },
                  child: Text(l10n.saveChanges),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final email = context.read<AuthCubit>().state.email;
                    if (email == null || email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.noEmailForResetMessage)),
                      );
                      return;
                    }
                    try {
                      await context
                          .read<AuthRepository>()
                          .sendPasswordResetEmail(email);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.resetEmailSent)),
                      );
                    } catch (_) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.genericErrorMessage)),
                      );
                    }
                  },
                  child: Text(l10n.sendResetEmail),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _mapChangeEmailFailure(BuildContext context, AuthFailure f) {
  final l10n = context.l10n;
  switch (f) {
    case AuthFailure.invalidEmail:
      return l10n.invalidEmailMessage;
    case AuthFailure.emailAlreadyInUse:
      return l10n.emailInUseMessage;
    case AuthFailure.requiresRecentLogin:
      return l10n.requiresRecentLoginMessage;
    default:
      return l10n.genericErrorMessage;
  }
}
