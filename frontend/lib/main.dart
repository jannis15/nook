import 'package:flutter/material.dart';
import 'package:nook/config/app_router.dart';
import 'package:nook/config/app_theme.dart';

void main() {
  runApp(const NookApp());
}

final _appRouter = AppRouter();

class NookApp extends StatelessWidget {
  const NookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nook',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: _appRouter.config(),
    );
  }
}
