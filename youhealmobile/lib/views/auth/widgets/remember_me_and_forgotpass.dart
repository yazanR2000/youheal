import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/utils/navigator.dart';
import 'package:youhealmobile/view_model/auth_view_model.dart';
import 'package:youhealmobile/views/auth/reset_password.dart';

class RememberMeAndForgotPass extends StatefulWidget {
  const RememberMeAndForgotPass({super.key});

  @override
  State<RememberMeAndForgotPass> createState() =>
      _RememberMeAndForgotPassState();
}

class _RememberMeAndForgotPassState extends State<RememberMeAndForgotPass> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthViewModel>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              authProvider.rememberMe = !authProvider.rememberMe;
            });
          },
          child: Row(
            children: [
              Radio(
                value: authProvider.rememberMe,
                groupValue: true,
                onChanged: (value) {
                  // setState(() {
                  //   authProvider.rememberMe = !authProvider.rememberMe;
                  // });
                },
              ),
              Text(
                tr('rememberMe'),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.titleSmall,
            foregroundColor: const Color(0xff95989A),
          ),
          onPressed: () {
            NavigationController.navigatorRoute(
              context: context,
              page: ResetPassword(),
            );
          },
          child: Text(
            tr('forgotPass'),
          ),
        ),
      ],
    );
  }
}
