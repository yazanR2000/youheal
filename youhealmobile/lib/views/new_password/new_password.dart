import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/components/custom_scaffold.dart';
import 'package:youhealmobile/view_model/auth_view_model.dart';

import '../../components/custom_elevated_button.dart';
import '../../components/form_field.dart';

class NewPassword extends StatelessWidget {
  final String phone;
  NewPassword({super.key, required this.phone});

  final _formKey = GlobalKey<FormState>();
  String? newPassword;

  Future _saveNewPassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await Provider.of<AuthViewModel>(context, listen: false).updatePassword(
        phone: phone,
        newPassword: newPassword!,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return CustomScaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: screenSize.height * 0.15,
            horizontal: screenSize.width * 0.1,
          ),
          child: Column(
            children: [
              SizedBox(
                height: screenSize.height * 0.15,
              ),
              Text(
                tr('newPassword'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  tr('enterYouNewPassword'),
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomFormField(
                hintText: tr("password"),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return tr('passEmpty');
                  } else if (value.length < 5) {
                    return tr('passValidation');
                  }
                  return null;
                },
                onSave: (value) {
                  newPassword = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Consumer<AuthViewModel>(
                builder:(context, viewModel, _) => CustomElevatedButton(
                  width: double.infinity,
                  onPressed: viewModel.isLoadingForAuth ? null : () => _saveNewPassword(context),
                  child: Text(
                    tr('submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
