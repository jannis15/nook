import 'package:flutter/material.dart';

/// Provides the centred, constrained layout shared by authentication pages.
class AuthPageScaffold extends StatelessWidget {
  /// Default constructor.
  const AuthPageScaffold({required this.child, super.key});

  /// Content displayed within the authentication page layout.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(padding: const EdgeInsets.all(24), child: child),
          ),
        ),
      ),
    );
  }
}
