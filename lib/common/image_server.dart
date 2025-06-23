import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageServer extends StatelessWidget {
  final String imageUrl;
  final double? borderRadius;
  final double? borderTopLeftRadius;
  final double? borderTopRightRadius;
  final double? borderBottomLeftRadius;
  final double? borderBottomRightRadius;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final VoidCallback? onLoadStart;
  final VoidCallback? onLoadEnd;
  final bool showActivityIndicator;
  final double? width;
  final double? height;

  const ImageServer({
    Key? key,
    required this.imageUrl,
    this.borderRadius,
    this.borderTopLeftRadius,
    this.borderTopRightRadius,
    this.borderBottomLeftRadius,
    this.borderBottomRightRadius,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.onLoadStart,
    this.onLoadEnd,
    this.showActivityIndicator = true,
    this.width,
    this.height,
  }) : super(key: key);

  BorderRadius _buildBorderRadius() {
    if (borderRadius != null) {
      return BorderRadius.circular(borderRadius!);
    }
    return BorderRadius.only(
      topLeft: Radius.circular(borderTopLeftRadius ?? 0),
      topRight: Radius.circular(borderTopRightRadius ?? 0),
      bottomLeft: Radius.circular(borderBottomLeftRadius ?? 0),
      bottomRight: Radius.circular(borderBottomRightRadius ?? 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _buildBorderRadius(),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) {
          onLoadStart?.call();
          return placeholder ??
              (showActivityIndicator
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink());
        },
        errorWidget: (context, url, error) =>
            errorWidget ?? const Icon(Icons.error),
        imageBuilder: (context, imageProvider) {
          // onLoadEnd is called here when the image has been built
          onLoadEnd?.call();
          return Image(
            image: imageProvider,
            fit: fit,
            width: width,
            height: height,
          );
        },
      ),
    );
  }
}
