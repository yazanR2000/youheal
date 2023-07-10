
import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final bool? isHidden;
  final bool? isObsecure;
  final Function? validator;
  final bool? isFinalNode;
  final TextInputType? textInputType;
  final Function? onSave;
  final Function? onChange;
  final TextStyle? errorStyle;
  final bool? enabled;
  final String? initialValue;
  final bool boxShadow;
  final Icon? suffixIcon;
  final TextEditingController? textEditingController;
  const CustomFormField({super.key, 
    required this.hintText,
    this.isHidden = false,
    this.isObsecure,
    this.validator,
    this.isFinalNode = false,
    this.textInputType,
    this.onSave,
    this.onChange,
    this.errorStyle,
    this.enabled = true,
    this.initialValue = '',
    this.boxShadow = true,
    this.suffixIcon,
    this.textEditingController
  });

  @override
  Widget build(BuildContext context) {
    if(textEditingController != null && initialValue == null){
      textEditingController!.clear();
    }
    return Visibility(
      visible: !isHidden!,
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          // color: Colors.white,
          boxShadow: [
            if (boxShadow)
              BoxShadow(
                color: const Color(0xff0000000d).withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: TextFormField(
          controller: textEditingController,
          autofocus: false,
          // initialValue: '',
          enabled: enabled,
          onChanged:
              onChange == null ? (value) {} : (value) => onChange!(value),
          onSaved: onSave == null ? (value) {} : (value) => onSave!(value!),
          keyboardType: textInputType ?? TextInputType.emailAddress,
          textInputAction:
              isFinalNode! ? TextInputAction.done : TextInputAction.next,
          validator:
              validator == null ? (value) {
                return null;
              } : (value) => validator!(value),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.black),
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            errorStyle: errorStyle ?? const TextStyle(),
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
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.titleMedium,
          ),
          obscureText: isObsecure ?? false,
        ),
      ),
    );
  }
}
