import 'package:flutter/material.dart';

class NavigationIcon extends StatelessWidget {
  final Function onTap;
  final int index;
  final IconData icon;
  final String label;
  final Color? color;
  const NavigationIcon(
      {super.key,
      required this.onTap,
      required this.index,
      required this.icon,
      required this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
              ),
            )
          ],
        ),
      ),
    );
  }
}
