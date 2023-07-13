import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


class PhoneNumberField extends StatelessWidget {
  final Function onSave;
  const PhoneNumberField({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'PhoneNumber',
      flightShuttleBuilder: (flightContext, animation, flightDirection,
          fromHeroContext, toHeroContext) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xff0000000d).withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              ),
            ],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          // color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0xff0000000d).withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        
        child: IntlPhoneField(
          flagsButtonPadding: const EdgeInsets.symmetric(horizontal: 10),
          onSaved: (newValue) => onSave(newValue!.number.toString()),
          textAlign: EasyLocalization.of(context)!.currentLocale ==
                  const Locale('ar', 'EG')
              ? TextAlign.right
              : TextAlign.left,
          initialCountryCode: "JO",
          
          textInputAction: TextInputAction.next,

          disableLengthCheck: true,
          showDropdownIcon: false,
          
          // showCountryFlag: true,
          // showCountryCode: false,
          invalidNumberMessage: tr('phoneNotValidForm'),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.black),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(color: Colors.white, width: 0.0),
            ),
            hintText: tr('phonenumber'),
            hintStyle: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
