import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nook/presentation/app_bar/main_app_bar.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MainAppBar(),
      body: Center(child: Text('Home')),
    );
  }
}
