import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;
  final int index;
  const NavigationButton(
      {super.key,
      required this.icon,
      required this.text,
      required this.onTap,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              Icon(icon),
              Text(
                text,
                style: const TextStyle(fontSize: 12.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
