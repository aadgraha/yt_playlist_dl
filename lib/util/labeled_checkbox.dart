import 'package:flutter/material.dart';

class LabeledCheckbox extends StatefulWidget {
  final String label;
  final bool initialValue;
  final Function(bool?) onChanged;

  const LabeledCheckbox({
    super.key,
    required this.label,
    this.initialValue = false,
    required this.onChanged,
  });

  @override
  State<LabeledCheckbox> createState() => _LabeledCheckboxState();
}

class _LabeledCheckboxState extends State<LabeledCheckbox> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        setState(() => value = !value);
        widget.onChanged(value);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: (val) {
                setState(() => value = val ?? false);
                widget.onChanged(val);
              },
            ),
            Expanded(
              child: Text(
                widget.label,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}