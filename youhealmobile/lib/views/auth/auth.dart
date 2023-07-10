import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:youhealmobile/components/spinkit.dart';
import 'package:youhealmobile/utils/enums.dart';
import 'package:youhealmobile/view_model/auth_view_model.dart';
import 'package:youhealmobile/components/custom_drop_down.dart';
import 'package:youhealmobile/views/auth/widgets/login_with.dart';
import 'package:youhealmobile/views/auth/widgets/remember_me_and_forgotpass.dart';

import '../../components/custom_scaffold.dart';
import '../../components/form_field.dart';
import '../../components/custom_elevated_button.dart';

import '../../components/heroes/phone_number_field.dart';

class Auth extends StatelessWidget {
  static const routeName = 'AuthScreen';
  Auth({super.key});

  bool rememberMe = false;

  final _formKey = GlobalKey<FormState>();

  Future _authenticate(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await Provider.of<AuthViewModel>(context, listen: false)
          .authenticate(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return WillPopScope(
      onWillPop: () async {
        final authProvider = Provider.of<AuthViewModel>(context, listen: false);
        if ((authProvider.authType == AuthType.signup ||
                authProvider.authType == AuthType.reset) &&
            !authProvider.isLoadingForAuth) {
          authProvider.changeAuthType(AuthType.login);
        }
        return Future.delayed(Duration.zero);
      },
      child: CustomScaffold(
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 20,top: screenSize.height * 0.15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Consumer<AuthViewModel>(
                  builder: (context, authProvider, _) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          tr(authProvider.authType == AuthType.login
                              ? 'signin'
                              : authProvider.authType == AuthType.signup
                                  ? 'createAccount'
                                  : 'resetPass'),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (authProvider.authType == AuthType.reset)
                          const SizedBox(
                            height: 30,
                          ),
                        if (authProvider.authType == AuthType.reset)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10),
                            child: Text(
                              tr('resetPassText'),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        // if(authProvider.authType == AuthType.signup)
                        AnimatedOpacity(
                          key: const Key('fullname'),
                          opacity:
                              authProvider.authType == AuthType.login &&
                                      authProvider.authType !=
                                          AuthType.reset
                                  ? 0
                                  : 1,
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.linear,
                          child: CustomFormField(
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return tr('fullnameEmpty');
                              }
                              return null;
                            },
                            onSave: (value) {
                              authProvider.authenticateUserData[
                                  'full_name'] = value;
                            },
                            isHidden: authProvider.authType ==
                                    AuthType.login ||
                                authProvider.authType == AuthType.reset,
                            hintText: tr('fullname'),
                          ),
                        ),

                        AnimatedContainer(
                          margin:
                              authProvider.authType == AuthType.login ||
                                      authProvider.authType ==
                                          AuthType.reset
                                  ? EdgeInsets.zero
                                  : const EdgeInsets.only(top: 20),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear,
                          child: Column(
                            children: [
                              PhoneNumberField(
                                onSave: (value) {
                                  authProvider.authenticateUserData[
                                      'phone'] = value;
                                },
                              ),
                              if (authProvider.authType !=
                                  AuthType.reset)
                                const SizedBox(
                                  height: 20,
                                ),
                              if (authProvider.authType !=
                                  AuthType.reset)
                                CustomFormField(
                                  validator: (String? value) {
                                    if (value == null ||
                                        value.isEmpty) {
                                      return tr('passEmpty');
                                    } else if (value.length < 5) {
                                      return tr('passValidation');
                                    }
                                    return null;
                                  },
                                  onSave: (value) {
                                    authProvider.authenticateUserData[
                                        'password'] = value;
                                  },
                                  onChange: (value) =>
                                      authProvider.authenticateUserData[
                                          'password'] = value,
                                  hintText: tr('password'),
                                  isObsecure: true,
                                  isFinalNode: authProvider.authType ==
                                          AuthType.login
                                      ? true
                                      : false,
                                ),
                            ],
                          ),
                        ),
                        if (authProvider.authType == AuthType.signup)
                          const SizedBox(
                            height: 20,
                          ),
                        AnimatedOpacity(
                          key: const Key('confirmPass'),
                          opacity:
                              authProvider.authType == AuthType.login
                                  ? 0
                                  : 1,
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.linear,
                          child: CustomFormField(
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return tr('passEmpty');
                              } else if (value !=
                                  authProvider.authenticateUserData[
                                      'password']) {
                                return tr('confirmPassNotEqual');
                              }
                              return null;
                            },
                            isHidden: authProvider.authType ==
                                    AuthType.login ||
                                authProvider.authType == AuthType.reset,
                            hintText: tr('confirmPass'),
                            isObsecure: true,
                            isFinalNode: true,
                          ),
                        ),
                        if (authProvider.authType == AuthType.signup)
                          const SizedBox(
                            height: 20,
                          ),

                        AnimatedOpacity(
                          key: const Key('gender'),
                          opacity:
                              authProvider.authType == AuthType.login &&
                                      authProvider.authType !=
                                          AuthType.reset
                                  ? 0
                                  : 1,
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.linear,
                          child: CustomDropDown(
                            from: 'Auth',
                            isVisible: authProvider.authType ==
                                AuthType.signup,
                            selectedValue: tr('male'),
                            hintText: tr('gender'),
                            options: [tr('male'), tr('female')],
                            onChange: (value) {
                              Provider.of<AuthViewModel>(context,
                                          listen: false)
                                      .authenticateUserData['gender'] =
                                  value;
                            },
                          ),
                        ),
                        if (authProvider.authType == AuthType.login)
                          const SizedBox(
                            height: 10,
                          ),
                        if (authProvider.authType == AuthType.login)
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
                                  tr(
                                    authProvider.authType ==
                                            AuthType.login
                                        ? 'signin'
                                        : authProvider.authType ==
                                                AuthType.signup
                                            ? 'signup'
                                            : 'resetPass',
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 15,
                        ),
                        if (authProvider.authType == AuthType.login)
                          Text(
                            tr('or'),
                          ),
                        if (authProvider.authType == AuthType.login)
                          const SizedBox(
                            height: 15,
                          ),
                        if (authProvider.authType == AuthType.login)
                          const LoginWith(),
                        if (authProvider.authType == AuthType.login)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(tr('dontHaveAccount'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall),
                              const SizedBox(
                                width: 5,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          fontWeight: FontWeight.w600),
                                ),
                                onPressed: () => authProvider
                                    .changeAuthType(AuthType.signup),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
