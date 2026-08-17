import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PinImage extends StatelessWidget {
  final String url;
  final double? height;
  final BorderRadius borderRadius;

  const PinImage({
    super.key,
    required this.url,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: url,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: const Color(0xFFE9E9E9),
          highlightColor: const Color(0xFFF7F7F7),
          child: Container(color: Colors.white),
        ),
        errorWidget: (_, __, ___) => Container(
          color: const Color(0xFFEDEDED),
          child: const Icon(Icons.image_not_supported_outlined),
        ),
      ),
    );
  }
}
