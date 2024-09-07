import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';



class CustomDropdownButton<T> extends StatelessWidget {
  final String labelText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator<T>? validator;

  const CustomDropdownButton({
    Key? key,
    required this.labelText,
    required this.items,
    this.value,
    this.onChanged,
    this.onTap,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(
      value: value,
      hint: Text(labelText),
      items: items,
      validator: validator,
      onChanged: onChanged,
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        elevation: 8,
      ),
      menuItemStyleData: MenuItemStyleData(
        customHeights: List<double>.filled(items.length, 48.0),
        selectedMenuItemBuilder: (context, child) => Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.red.withOpacity(0.1),
          ),
          child: child,
        ),
      ),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        fillColor: const Color(0xFFF2F2F2),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide:
              const BorderSide(color: Color.fromARGB(255, 212, 209, 209)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide:
              const BorderSide(color: Color.fromARGB(255, 223, 220, 220)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide:
              const BorderSide(color: Color.fromARGB(255, 212, 209, 209)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide:
              const BorderSide(color: Color.fromARGB(255, 223, 220, 220)),
        ),
      ),
    );
  }
}

class CustomDropdownButton2 extends StatefulWidget {
  final ValueChanged<String?> onValueChanged;
  final FormFieldValidator<String?>? validator; // Added validator as a parameter

  const CustomDropdownButton2({
    Key? key,
    required this.onValueChanged,
    required this.validator, // Added validator here
  }) : super(key: key);

  @override
  _CustomDropdownButton2State createState() => _CustomDropdownButton2State();
}

class _CustomDropdownButton2State extends State<CustomDropdownButton2> {
  String? _selectedValue;

  final List<String> _dropdownValues = [
    "Information",
    "Job",
    "Funding",
    "Requirement",
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      value: _selectedValue,
      hint:
          const Text('Select type'), // Show the label when no value is selected
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Circular border
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 212, 209, 209),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Circular border
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 223, 220, 220),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Circular border
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Circular border
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
      ),

      onChanged: (String? newValue) {
        setState(() {
          _selectedValue = newValue;
        });

        // Notify parent about the value change
        widget.onValueChanged(newValue);
      },
      validator: widget.validator, // Apply the validator here
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // Circular dropdown menu
          color: Colors.white, // Dropdown menu background color
        ),
        elevation: 8,
      ),
      menuItemStyleData: MenuItemStyleData(
        customHeights: List<double>.filled(_dropdownValues.length, 48.0),
        padding: const EdgeInsets.only(right: 10),
      ),
      buttonStyleData: ButtonStyleData(
        padding: const EdgeInsets.only(right: 10),
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // Circular dropdown button
          color: Colors.white,
        ),
      ),
      items: _dropdownValues
          .map(
            (value) => DropdownMenuItem<String>(
              value: value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(12), // Circular menu item border
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(value),
              ),
            ),
          )
          .toList(),
    );
  }
}
