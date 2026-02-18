import 'package:flutter/material.dart';

class DiscountCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final double height;

  const DiscountCard({
    Key? key,
    required this.child,
    this.color = Colors.blue,
    this.height = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: DiscountCardClipper(),
      child: Container(
        height: height,
        color: color,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Icon(
                Icons.local_offer,
                size: 100,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class DiscountCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 16); // Start top left with rounded corner
    path.arcToPoint(const Offset(16, 0), radius: const Radius.circular(16));
    path.lineTo(size.width - 60, 0); // Top edge
    path.lineTo(size.width, size.height / 2); // To point of tag
    path.lineTo(size.width - 60, size.height); // Bottom of tag
    path.lineTo(16, size.height); // Bottom edge
    path.arcToPoint(Offset(0, size.height - 16),
        radius: const Radius.circular(16)); // Bottom left rounded corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
