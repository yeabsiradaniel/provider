import 'package:flutter/material.dart';
import 'package:mobile/core/theme/radius.dart';

class AsymCard extends StatelessWidget {
  const AsymCard({
    super.key,
    this.child,
    this.color,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.borderRadius = AppRadius.cardRadius,
    this.borderColor,
    this.borderWidth = 0.0,
    this.shadowColor,
    this.elevation,
  });

  final Widget? child;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry borderRadius;
  final Color? borderColor;
  final double borderWidth;
  final Color? shadowColor;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).cardTheme.color,
        borderRadius: borderRadius,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
        boxShadow: elevation != null
            ? [
                BoxShadow(
                  color: shadowColor ?? Colors.black.withOpacity(0.08),
                  blurRadius: elevation!,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
