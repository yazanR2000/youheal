
import 'package:flutter/material.dart';
import 'package:youhealmobile/components/my_app_bar/my_app_bar.dart';
import 'package:youhealmobile/utils/resources.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final bool noAppBar;
  const CustomScaffold({super.key, required this.body,this.noAppBar = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: noAppBar ? null : const MyAppBar(),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(Resources.background,fit: BoxFit.fitHeight,),
          ),
          Positioned.fill(child: body),
        ],
      ),
    );
  }
}
