import 'package:flutter/material.dart';

import 'router/app_router.dart';

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
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF8F7357),
      ),
      routerConfig: _appRouter.config(),
    );
  }
}
