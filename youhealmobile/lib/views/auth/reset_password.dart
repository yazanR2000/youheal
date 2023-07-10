import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/components/custom_scaffold.dart';
import 'package:youhealmobile/utils/navigator.dart';
import 'package:youhealmobile/view_model/auth_view_model.dart';
import 'package:youhealmobile/views/otp/otp.dart';

import '../../components/custom_elevated_button.dart';
import '../../components/heroes/phone_number_field.dart';
import '../../components/spinkit.dart';
import '../../utils/enums.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});

  final _formKey = GlobalKey<FormState>();

  Future _authenticate(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final authProvider = Provider.of<AuthViewModel>(context, listen: false);
      authProvider.authType = AuthType.reset;
      final phone = authProvider.authenticateUserData['phone'];
      await authProvider.resetPassword(
        phone: phone,
        context: context,
      );
    }
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
              horizontal: screenSize.width * 0.1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenSize.height * 0.15,
                ),
                Text(
                  tr('resetPass'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    tr('resetPassText'),
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
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
                authProvider.isLoadingForAuth
                    ? Spinkit.spinKit()
                    : CustomElevatedButton(
                        width: double.infinity,
                        onPressed: () => _authenticate(context),
                        child: Text(
                          tr('send'),
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
