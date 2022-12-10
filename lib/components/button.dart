import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function() onTap;
  final String title;
  final Color color;
  const Button({
    super.key,
    required this.onTap,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(5),
          padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: color))),
          backgroundColor: MaterialStateProperty.all(color)),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }
}
