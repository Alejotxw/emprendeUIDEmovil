import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Clase centralizada para gestionar todos los assets de la aplicación.
/// Proporciona constantes para rutas de imágenes, íconos y fuentes,
/// además de widgets con manejo de errores para placeholders.
class AppAssets {
  // Rutas base
  static const String _imagesPath = 'assets/images/';
  static const String _iconsPath = 'assets/icons/';
  static const String _fontsPath = 'assets/fonts/';

  // Imágenes
  static const String logo = '${_imagesPath}logo.png';
  static const String placeholderImage = '${_imagesPath}placeholder.png';
  static const String backgroundPattern = '${_imagesPath}background_pattern.png';

  // Íconos SVG
  static const String iconHome = '${_iconsPath}icon_home.svg';
  static const String iconProfile = '${_iconsPath}icon_profile.svg';
  static const String iconSettings = '${_iconsPath}icon_settings.svg';
  static const String iconCart = '${_iconsPath}icon_cart.svg';
  static const String iconSearch = '${_iconsPath}icon_search.svg';
  static const String iconFavorite = '${_iconsPath}icon_favorite.svg';

  // Fuentes (usando fuentes del sistema)
  static const String fontRoboto = 'Roboto';
  static const String fontDefault = 'Roboto';

  /// Widget para imágenes con manejo de errores.
  /// Si la imagen no existe, muestra un placeholder gris con ícono.
  static Widget image(
    String assetPath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
  }) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width ?? 100,
          height: height ?? 100,
          color: Colors.grey.shade300,
          child: Icon(
            Icons.broken_image,
            color: Colors.grey.shade600,
            size: (width ?? 100) * 0.5,
          ),
        );
      },
    );
  }

  /// Widget para íconos SVG con manejo de errores.
  /// Si el ícono no existe, muestra un ícono de Material Design.
  static Widget svgIcon(
    String assetPath, {
    double? width,
    double? height,
    Color? color,
  }) {
    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
      placeholderBuilder: (context) => Icon(
        Icons.error,
        size: width ?? 24,
        color: color ?? Colors.grey,
      ),
    );
  }

  /// Widget para íconos PNG con manejo de errores.
  /// Si el ícono no existe, muestra un ícono de Material Design.
  static Widget pngIcon(
    String assetPath, {
    double? size,
    Color? color,
  }) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.error,
          size: size ?? 24,
          color: color ?? Colors.grey,
        );
      },
    );
  }

  /// Método para obtener el nombre de la fuente.
  /// Útil para TextStyle(fontFamily: AppAssets.fontFamily('Roboto'))
  static String fontFamily(String familyName) {
    switch (familyName.toLowerCase()) {
      case 'roboto':
        return AppAssets.fontRoboto;
      default:
        return AppAssets.fontDefault;
    }
  }
}
