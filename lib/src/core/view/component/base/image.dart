import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../gen/app_assets.dart';
import '../../../utils/const/time.dart';

class AppAssetsImage extends StatelessWidget {
  const AppAssetsImage(
    this.url, {
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.radius = 0,
    this.shape = BoxShape.rectangle,
    this.backgroundColor,
    this.padding,
    this.margin,
  });
  final String url;
  final double? height;
  final double? width;
  final BoxFit fit;
  final double radius;
  final BoxShape shape;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        shape: shape,
        color: backgroundColor,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(radius)
            : null,
      ),
      child: Image.asset(
        url,
        width: width,
        height: height,
        fit: fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            return child;
          }
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: AnimationDurations.defaultDuration,
            curve: Curves.easeOut,
            child: child,
          );
        },
        errorBuilder: (context, url, error) => _ErrorImageWidget(
          height: height,
          width: width,
          radius: 0,
          fit: fit,
        ),
      ),
    );
  }
}

class AppAssetsSvg extends StatelessWidget {
  const AppAssetsSvg(
    this.url, {
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.radius = 0,
    this.shape = BoxShape.rectangle,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.color,
  });
  final String url;
  final double? height;
  final double? width;
  final BoxFit fit;
  final double radius;
  final BoxShape shape;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        shape: shape,
        color: backgroundColor,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(radius)
            : null,
      ),
      child: SvgPicture.asset(
        url,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (context) => _Placeholder(
          height: height,
          width: width,
          radius: radius,
          fit: fit,
        ),
      ),
    );
  }
}

class AppAssetsSvgSafe extends StatelessWidget {
  const AppAssetsSvgSafe(
    this.url, {
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.radius = 0,
    this.shape = BoxShape.rectangle,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.color,
  });
  final String url;
  final double? height;
  final double? width;
  final BoxFit fit;
  final double radius;
  final BoxShape shape;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        shape: shape,
        color: backgroundColor,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(radius)
            : null,
      ),
      child: SvgPicture.asset(
        url,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (context) => SizedBox(height: height, width: width),
      ),
    );
  }
}

class AppNetworkImageProviderRounded extends CachedNetworkImageProvider {
  const AppNetworkImageProviderRounded(super.url);
}

class AppNetworkImageRounded extends StatelessWidget {
  const AppNetworkImageRounded(
    this.imageUrl, {
    this.placeholder,
    this.imageErrorPlaceHolder = AppAssets.ASSETS_IMAGES_PLACEHOLDER_PNG,
    this.radius = 0,
    this.ignoreImageRadius = false,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.boxShadow,
    this.backgroundColor,
    this.maxHeightDiskCache = 600,
    this.maxWidthDiskCache = 600,
    super.key,
    this.circleShape = false,
    this.border,
    this.padding,
    this.margin,
    this.fadeInDuration = Duration.zero,
  });

  final String? imageUrl;
  final Widget Function(BuildContext, String)? placeholder;
  final String imageErrorPlaceHolder;
  final double radius;
  final bool ignoreImageRadius;
  final double? height;
  final double? width;
  final BoxFit fit;
  final List<BoxShadow>? boxShadow;
  final Color? backgroundColor;
  final int? maxHeightDiskCache;
  final int? maxWidthDiskCache;
  final bool circleShape;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Duration fadeInDuration;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      key: UniqueKey(),
      fadeInDuration: fadeInDuration,
      imageUrl: imageUrl ?? '',
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: circleShape ? BoxShape.circle : BoxShape.rectangle,
          border: border,
          borderRadius: ignoreImageRadius || circleShape
              ? null
              : BorderRadius.circular(radius),
          image: DecorationImage(image: imageProvider, fit: fit),
          boxShadow: boxShadow,
        ),
      ),
      placeholder:
          placeholder ??
          (context, url) =>
              _Placeholder(height: 0, width: 0, radius: radius, fit: fit),
      errorWidget: (context, url, error) => _ErrorImageWidget(
        height: height,
        width: width,
        radius: radius,
        fit: fit,
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.height,
    required this.width,
    required this.radius,
    required this.fit,
  });

  final double? height;
  final double? width;
  final double radius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        image: DecorationImage(
          image: const AssetImage(AppAssets.ASSETS_IMAGES_PLACEHOLDER_PNG),
          fit: fit,
        ),
      ),
    );
  }
}

class _ErrorImageWidget extends StatelessWidget {
  const _ErrorImageWidget({
    required this.height,
    required this.width,
    required this.radius,
    required this.fit,
  });

  final double? height;
  final double? width;
  final double radius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        image: DecorationImage(
          image: const AssetImage(AppAssets.ASSETS_IMAGES_PLACEHOLDER_PNG),
          fit: fit,
        ),
      ),
    );
  }
}
