import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/contact_method_model.dart';

class ContactMethodsWidget extends StatelessWidget {
  final List<ContactMethodModel> contactMethods;
  final bool showLabels;
  final double iconSize;
  final Axis direction;

  const ContactMethodsWidget({
    super.key,
    required this.contactMethods,
    this.showLabels = true,
    this.iconSize = 24.0,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    if (contactMethods.isEmpty) {
      return const SizedBox.shrink();
    }

    final children = contactMethods.map((method) => _buildContactButton(method)).toList();

    if (direction == Axis.vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    } else {
      return Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: children,
      );
    }
  }

  Widget _buildContactButton(ContactMethodModel method) {
    return InkWell(
      onTap: () => _launchContactMethod(method),
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: method.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: method.color.withOpacity(0.3),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              method.icon,
              size: iconSize,
              color: method.color,
            ),
            if (showLabels) ...[
              const SizedBox(width: 8.0),
              Text(
                method.displayLabel,
                style: TextStyle(
                  color: method.color,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _launchContactMethod(ContactMethodModel method) async {
    String url = '';

    switch (method.type) {
      case ContactMethodType.phone:
        url = 'tel:${method.value}';
        break;
      case ContactMethodType.whatsapp:
        // Remove any non-numeric characters for WhatsApp
        final phoneNumber = method.value.replaceAll(RegExp(r'[^\d+]'), '');
        url = 'https://wa.me/$phoneNumber';
        break;
      case ContactMethodType.email:
        url = 'mailto:${method.value}';
        break;
      case ContactMethodType.instagram:
        url = 'https://instagram.com/${method.value.replaceFirst('@', '')}';
        break;
      case ContactMethodType.facebook:
        url = method.value.startsWith('http') ? method.value : 'https://facebook.com/${method.value}';
        break;
      case ContactMethodType.twitter:
        url = 'https://twitter.com/${method.value.replaceFirst('@', '')}';
        break;
      case ContactMethodType.website:
        url = method.value.startsWith('http') ? method.value : 'https://${method.value}';
        break;
      case ContactMethodType.other:
        // For other types, try to launch as URL if it looks like one
        if (method.value.contains('http') || method.value.contains('www')) {
          url = method.value.startsWith('http') ? method.value : 'https://${method.value}';
        } else {
          // If it's not a URL, we can't launch it automatically
          return;
        }
        break;
    }

    if (url.isNotEmpty) {
      try {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } catch (e) {
        // Handle error silently or show a snackbar
        print('Error launching URL: $e');
      }
    }
  }
}

// Convenience widget for displaying contact methods in a card
class ContactMethodsCard extends StatelessWidget {
  final List<ContactMethodModel> contactMethods;
  final String title;
  final EdgeInsetsGeometry? padding;

  const ContactMethodsCard({
    super.key,
    required this.contactMethods,
    this.title = 'Métodos de Contacto',
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16.0),
            if (contactMethods.isEmpty)
              const Text(
                'No hay métodos de contacto disponibles',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              ContactMethodsWidget(
                contactMethods: contactMethods,
                direction: Axis.vertical,
                showLabels: true,
              ),
          ],
        ),
      ),
    );
  }
}