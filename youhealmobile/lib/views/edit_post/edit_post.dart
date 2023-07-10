import 'package:flutter/material.dart';
import 'package:youhealmobile/components/custom_scaffold.dart';

class EditPost extends StatelessWidget {
  final Widget post;
  const EditPost({super.key,required this.post});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return CustomScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.15,horizontal: 20),
        child: post,
      ),
    );
  }
}
