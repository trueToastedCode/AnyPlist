import 'package:flutter/material.dart';

class OpenButton extends StatelessWidget {
  final bool enabled;
  final Function onTap;
  final String text;
  final LinearGradient gradient;

  const OpenButton({
    Key? key,
    required this.onTap,
    required this.enabled,
    required this.text,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 30,
        width: 100,
        decoration: BoxDecoration(
          gradient: gradient
        ),
        foregroundDecoration: enabled
            ? null
            : BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          backgroundBlendMode: BlendMode.saturation,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? () => onTap() : null,
            splashColor: Colors.lightBlue,
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xff000000),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
