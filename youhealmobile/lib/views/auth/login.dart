import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youhealmobile/components/custom_scaffold.dart';
import 'package:youhealmobile/utils/enums.dart';
import 'package:youhealmobile/utils/navigator.dart';
import 'package:youhealmobile/view_model/auth_view_model.dart';
import 'package:youhealmobile/views/auth/signup.dart';

import '../../components/custom_elevated_button.dart';
import '../../components/form_field.dart';
import '../../components/heroes/phone_number_field.dart';
import '../../components/spinkit.dart';
import 'widgets/remember_me_and_forgotpass.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future _authenticate(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final authProvider = Provider.of<AuthViewModel>(context, listen: false);
      authProvider.authType = AuthType.login;
      await authProvider.authenticate(context);
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final prefrences = await SharedPreferences.getInstance();
      await prefrences.setBool("showOnboarding", false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return CustomScaffold(
      body: Form(
        key: _formKey,
        child: Consumer<AuthViewModel>(
          builder: (context, authProvider, _) => SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: screenSize.height * 0.15,
              horizontal: screenSize.width * 0.08,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenSize.height * 0.15,
                ),
                Text(
                  tr('signin'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                PhoneNumberField(
                  onSave: (value) {
                    authProvider.authenticateUserData['phone'] = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomFormField(
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return tr('passEmpty');
                    } else if (value.length < 5) {
                      return tr('passValidation');
                    }
                    return null;
                  },
                  onSave: (value) {
                    authProvider.authenticateUserData['password'] = value;
                  },
                  onChange: (value) => authProvider
                      .authenticateUserData['password'] = value,
                  hintText: tr('password'),
                  isObsecure: true,
                  isFinalNode: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                const RememberMeAndForgotPass(),
                const SizedBox(
                  height: 20,
                ),
                authProvider.isLoadingForAuth
                    ? Spinkit.spinKit()
                    : CustomElevatedButton(
                        width: double.infinity,
                        onPressed: () => _authenticate(context),
                        child: Text(
                          tr('signin'),
                        ),
                      ),
                const SizedBox(
                  height: 15,
                ),
                // Text(
                //   tr('or'),
                // ),
                // const SizedBox(
                //   height: 15,
                // ),
                // const LoginWith(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tr('dontHaveAccount'),
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(
                      width: 5,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        NavigationController.navigatorRoute(context: context, page: Signup());
                      },
                      child: Text(
                        tr('createAccount'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
