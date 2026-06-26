import 'package:flutter/material.dart' hide Banner;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zana_shop/data/model/banner.dart';

class BannerWidget extends StatelessWidget {
  final Banner banner;
  final double? width;
  final double? height;
  final double? aspectRatio;
  final VoidCallback? onTap;

  const BannerWidget({
    super.key,
    required this.banner,
    this.width,
    this.height,
    this.aspectRatio,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveAspectRatio =
        aspectRatio ?? (width == null && height == null ? 16 / 9 : null);

    Widget bannerContent = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: banner.image,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey.shade300,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade300,
          child: const Icon(Icons.error, color: Colors.red),
        ),
      ),
    );

    if (effectiveAspectRatio != null) {
      bannerContent = AspectRatio(
        aspectRatio: effectiveAspectRatio,
        child: bannerContent,
      );
    }

    if (banner.text.isNotEmpty) {
      bannerContent = Stack(
        fit: StackFit.passthrough,
        children: [
          bannerContent,
          Positioned(
            bottom: 44,
            left: 16,
            right: 16,
            child: Text(
              banner.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    return GestureDetector(onTap: onTap ?? () {}, child: bannerContent);
  }
}
