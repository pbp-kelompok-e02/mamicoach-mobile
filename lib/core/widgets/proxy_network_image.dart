import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart';

/// Centralized network image loader that routes requests through
/// the Django `/proxy/image/?url=...` endpoint.
///
/// - Accepts absolute (http/https) and relative (`/media/...`) URLs.
/// - Avoids double-proxying if the url already targets `/proxy/image/`.
class ProxyNetworkImage extends StatelessWidget {
  final String? url;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final AlignmentGeometry alignment;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;
  final WidgetBuilder? placeholder;
  final Widget Function(BuildContext, Object)? errorWidget;

  const ProxyNetworkImage(
    this.url, {
    super.key,
    this.fit,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.errorBuilder,
    this.errorWidget,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = resolveAbsoluteUrl(url);
    if (resolved == null) {
      return placeholder?.call(context) ?? const SizedBox.shrink();
    }

    final proxied = toProxyUrl(resolved);

    return Image.network(
      proxied,
      width: width,
      height: height,
      alignment: alignment,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder?.call(context) ?? const SizedBox.shrink();
      },
      errorBuilder: errorBuilder ?? (context, error, stackTrace) {
        if (errorWidget != null) return errorWidget!(context, error);
        return placeholder?.call(context) ?? const Icon(Icons.broken_image);
      },
    );
  }
}

/// Convert either an absolute http(s) url or a relative `/...` path
/// into an absolute URL pointing at the API host.
String? resolveAbsoluteUrl(String? url) {
  if (url == null) return null;
  final trimmed = url.trim();
  if (trimmed.isEmpty) return null;

  final lower = trimmed.toLowerCase();
  if (lower.startsWith('http://') || lower.startsWith('https://')) {
    return trimmed;
  }

  if (trimmed.startsWith('/')) {
    return '${ApiConstants.baseUrl}$trimmed';
  }

  // Unknown scheme (e.g., data:, file:). Return as-is and let Image handle it.
  return trimmed;
}

/// Build the Django proxy URL for a fully qualified target.
String toProxyUrl(String absoluteUrl) {
  final proxyBase = '${ApiConstants.baseUrl}/proxy/image/?url=';
  if (absoluteUrl.startsWith(proxyBase)) return absoluteUrl;
  return '$proxyBase${Uri.encodeComponent(absoluteUrl)}';
}

/// Use this when you need an ImageProvider (e.g., CircleAvatar.backgroundImage).
/// Caller should only call this when they already have a non-null URL.
ImageProvider proxyNetworkImageProvider(String url) {
  final resolved = resolveAbsoluteUrl(url) ?? url;
  return NetworkImage(toProxyUrl(resolved));
}
