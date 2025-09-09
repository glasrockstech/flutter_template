import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_template/l10n/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/features/auth/cubit/auth_cubit.dart';
import 'package:flutter_template/features/settings/view/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final email = context.select((AuthCubit c) => c.state.email);
    final title = _index == 0
        ? l10n.homeTitle
        : _index == 1
            ? l10n.accountTitle
            : l10n.settingsTitle;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.signOutTooltip,
            onPressed: () async {
              await context.read<AuthCubit>().signOut();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/auth', (r) => false);
              }
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: [
          // Home tab
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.welcomeMessage),
                if (email != null) ...[
                  const SizedBox(height: 8),
                  Text(email, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ],
            ),
          ),
          // Account tab
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  email ?? '-',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    await context.read<AuthCubit>().signOut();
                    if (context.mounted) {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/auth', (r) => false);
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: Text(l10n.signOutTooltip),
                ),
              ],
            ),
          ),
          // Settings tab
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.homeTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.accountTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.settingsTitle,
          ),
        ],
      ),
    );
  }
}
