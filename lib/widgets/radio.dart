import 'package:flutter/material.dart';

class PrimaryRadioGroup extends StatelessWidget {
  final String? groupValue;
  final void Function(String?)? onChanged;

  const PrimaryRadioGroup({
    Key? key,
    required this.groupValue,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: <Widget>[
          SizedBox(
            child: ListTile(
              title: const Text('Shorten'),
              leading: Radio<String?>(
                value: "shorten",
                groupValue: groupValue,
                onChanged: onChanged,
              ),
              onTap: onChanged != null ? () => onChanged!("shorten") : null,
            ),
            width: 180,
          ),
          SizedBox(
            child: ListTile(
              title: const Text('Alias'),
              leading: Radio<String?>(
                value: "alias",
                groupValue: groupValue,
                onChanged: onChanged,
              ),
              onTap: onChanged != null ? () => onChanged!("alias") : null,
            ),
            width: 180,
          ),
        ],
      ),
      physics: const BouncingScrollPhysics(),
    );
  }
}
