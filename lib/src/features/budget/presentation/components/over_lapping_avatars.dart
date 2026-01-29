import 'package:flutter/material.dart';

class OverlappingAvatars extends StatelessWidget {
  final List<String> imageUrls;
  final double size;
  final double overlap;

  const OverlappingAvatars({
    super.key,
    required this.imageUrls,
    this.size = 36,
    this.overlap = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size + (imageUrls.length - 1) * (size - overlap),
      child: Stack(
        children: List.generate(imageUrls.length, (index) {
          return Positioned(
            left: index * (size - overlap),
            child: CircleAvatar(
              radius: size / 2,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: (size / 2) - 2,
                backgroundImage: NetworkImage(imageUrls[index]),
              ),
            ),
          );
        }),
      ),
    );
  }
}
