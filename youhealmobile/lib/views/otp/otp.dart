import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/components/custom_elevated_button.dart';
import 'package:youhealmobile/components/custom_scaffold.dart';
import 'package:youhealmobile/view_model/otp_view_model.dart';
import 'dart:ui' as ui;
class OTP extends StatefulWidget {
  final bool forgetPassword;
  final int userId;
  final String? phone;
  const OTP(
      {super.key,
      this.forgetPassword = false,
      required this.userId,
      this.phone});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  bool hasError = false;
  String pin = "";
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return CustomScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            vertical: screenSize.height * 0.15,
            horizontal: screenSize.width * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: screenSize.height * 0.15,
            ),
            Text(
              tr('verificationCode'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                tr('addOtpText'),
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Directionality(
              textDirection: ui.TextDirection.ltr,
              child: OTPTextField(
                length: 4,
                width: double.infinity,
                fieldWidth: 50,
                hasError: hasError,
                style: const TextStyle(fontSize: 17),
                textFieldAlignment: MainAxisAlignment.spaceBetween,
                fieldStyle: FieldStyle.box,
                
                onCompleted: (pin) {
                  print("===================");
                  print("Completed: $pin");
                  this.pin = pin;
                  print("===================");
                },
                // otpFieldStyle: OtpFieldStyle(
                //   enabledBorderColor: Colors.blue,
                //   disabledBorderColor: Colors.grey,
                // ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: Consumer<OTPViewModel>(
                builder: (context, viewModel, _) => CustomElevatedButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () async {
                          if (pin.length < 4) {
                            setState(() {
                              hasError = true;
                            });
                          } else {
                            setState(() {
                              hasError = false;
                            });
                            if (widget.forgetPassword) {
                              await viewModel.verifyResetPassword(
                                  phone: widget.phone!,
                                  otp: pin,
                                  context: context);
                            } else {
                              await viewModel.verifyAccount(
                                  userId: widget.userId,
                                  code: pin,
                                  context: context);
                            }
                          }
                        },
                  child: Text(
                    tr("verify"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
