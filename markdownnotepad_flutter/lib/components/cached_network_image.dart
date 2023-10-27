import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MDNCachedNetworkImage extends StatelessWidget {
  final String imageURL;
  final Size progressBarSize;
  final Duration fadeInDuration, fadeOutDuration;

  const MDNCachedNetworkImage({
    super.key,
    required this.imageURL,
    this.progressBarSize = const Size(50.0, 50.0),
    this.fadeInDuration = const Duration(milliseconds: 50),
    this.fadeOutDuration = const Duration(milliseconds: 50),
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration,
      imageUrl: imageURL,
      imageBuilder: (context, imageProvider) => Image(
        image: imageProvider,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
        height: progressBarSize.width,
        width: progressBarSize.height,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
