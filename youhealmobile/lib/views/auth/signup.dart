import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/components/custom_scaffold.dart';
import 'package:youhealmobile/view_model/auth_view_model.dart';

import '../../components/custom_drop_down.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/form_field.dart';
import '../../components/heroes/phone_number_field.dart';
import '../../components/spinkit.dart';
import '../../utils/enums.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  Future _authenticate(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final authProvider = Provider.of<AuthViewModel>(context, listen: false);
      authProvider.authType = AuthType.signup;
      await authProvider.authenticate(context);
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return CustomScaffold(
      body: Form(
        key: _formKey,
        child: Consumer<AuthViewModel>(
          builder: (context, authProvider, _) => SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: screenSize.height * 0.2,
              horizontal: screenSize.width * 0.1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [    
                Text(
                  tr('createAccount'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomFormField(
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return tr('fullnameEmpty');
                    }
                    return null;
                  },
                  onSave: (value) {
                    authProvider.authenticateUserData['full_name'] =
                        value;
                  },
                  hintText: tr('fullname'),
                ),
                const SizedBox(
                  height: 20,
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
                    } else if (value.length <= 6) {
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
                  isFinalNode: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomFormField(
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return tr('passEmpty');
                    } else if (value !=
                        authProvider.authenticateUserData['password']) {
                      return tr('confirmPassNotEqual');
                    }
                    return null;
                  },
                  hintText: tr('confirmPass'),
                  isObsecure: true,
                  isFinalNode: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomDropDown(
                  from: 'Auth',
                  isVisible: true,
                  selectedValue: null,
                  hintText: tr('selectGender'),
                  options: [tr('male'), tr('female')],
                  onChange: (value) {
                    Provider.of<AuthViewModel>(context, listen: false)
                        .authenticateUserData['gender'] = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                authProvider.isLoadingForAuth
                    ? Spinkit.spinKit()
                    : CustomElevatedButton(
                        width: double.infinity,
                        onPressed: () => _authenticate(context),
                        child: Text(
                          tr('signup'),
                        ),
                      ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
