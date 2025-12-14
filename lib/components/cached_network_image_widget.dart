import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A reusable widget for displaying cached network images
/// This widget provides image caching functionality to reduce network usage
/// and improve performance across the application.
class CachedNetworkImageWidget extends StatelessWidget {
  /// The URL of the image to load
  final String imageUrl;

  /// Optional placeholder widget to show while loading
  final Widget? placeholder;

  /// Optional error widget to show if image fails to load
  final Widget? errorWidget;

  /// Optional width of the image
  final double? width;

  /// Optional height of the image
  final double? height;

  /// BoxFit for the image
  final BoxFit fit;

  /// Border radius for the image
  final BorderRadius? borderRadius;

  /// Background color while loading
  final Color? placeholderColor;

  /// Error color
  final Color? errorColor;

  /// Whether to show a progress indicator while loading
  final bool showProgressIndicator;

  /// Progress indicator color
  final Color? progressIndicatorColor;

  /// Whether to use fade in animation
  final bool fadeIn;

  /// Fade in duration
  final Duration fadeInDuration;

  /// Whether to use fade out animation
  final bool fadeOut;

  /// Fade out duration
  final Duration fadeOutDuration;

  /// Maximum width for the cached image
  final int? maxWidthDiskCache;

  /// Maximum height for the cached image
  final int? maxHeightDiskCache;

  /// Whether to use memory cache
  final bool useOldImageOnUrlChange;

  /// Filter quality for the image
  final FilterQuality filterQuality;

  const CachedNetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.placeholder,
    this.errorWidget,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderColor,
    this.errorColor,
    this.showProgressIndicator = true,
    this.progressIndicatorColor,
    this.fadeIn = true,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeOut = false,
    this.fadeOutDuration = const Duration(milliseconds: 100),
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.useOldImageOnUrlChange = false,
    this.filterQuality = FilterQuality.medium,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder ??
          (showProgressIndicator
              ? Container(
                  width: width,
                  height: height,
                  color: placeholderColor ?? Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      color: progressIndicatorColor ?? Colors.blue,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Container(
                  width: width,
                  height: height,
                  color: placeholderColor ?? Colors.grey[200],
                )),
      errorWidget: (context, url, error) => errorWidget ??
          Container(
            width: width,
            height: height,
            color: errorColor ?? Colors.grey[300],
            child: Icon(
              Icons.error_outline,
              color: Colors.grey[600],
              size: (width != null && height != null)
                  ? (width! < height! ? width! * 0.3 : height! * 0.3)
                  : 40,
            ),
          ),
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
      useOldImageOnUrlChange: useOldImageOnUrlChange,
      filterQuality: filterQuality,
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

/// Extension to easily convert NetworkImage to CachedNetworkImageProvider
extension NetworkImageExtension on NetworkImage {
  /// Converts NetworkImage to CachedNetworkImageProvider for use with Image widget
  CachedNetworkImageProvider toCachedProvider() {
    return CachedNetworkImageProvider(url);
  }
}

/// Helper class for managing image cache
class ImageCacheManager {
  /// Clear the entire image cache
  static Future<void> clearCache() async {
    imageCache.clear();
    imageCache.clearLiveImages();
  }

  /// Clear the cache for a specific image URL
  static Future<void> evictImage(String imageUrl) async {
    final provider = CachedNetworkImageProvider(imageUrl);
    await imageCache.evict(provider);
  }

  /// Get the current cache size in bytes
  static int getCurrentCacheSize() {
    return imageCache.currentSizeBytes;
  }

  /// Get the maximum cache size in bytes
  static int getMaximumCacheSize() {
    return imageCache.maximumSizeBytes;
  }

  /// Set the maximum cache size
  static void setMaximumCacheSize(int sizeInBytes) {
    imageCache.maximumSizeBytes = sizeInBytes;
  }

  /// Set the maximum number of images to cache
  static void setMaximumCacheObjects(int count) {
    imageCache.maximumSize = count;
  }
}
