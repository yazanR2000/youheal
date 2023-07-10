
import 'package:flutter/material.dart';


class CustomDropDown extends StatefulWidget {
  final bool isVisible;
  String? selectedValue;
  final List<String> options;
  final String hintText;
  final String from;
  final Function onChange;
  CustomDropDown({
    super.key,
    required this.isVisible,
    required this.selectedValue,
    required this.options,
    required this.hintText,
    required this.from,
    required this.onChange
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff0000000d).withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text(widget.hintText),
                  isExpanded: true,
                  value: widget.selectedValue,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  // elevation: 16,
                  style: Theme.of(context).textTheme.titleMedium,

                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      widget.selectedValue = value!;
                      widget.onChange(value);
                    });
                  },
                  items: widget.options
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
