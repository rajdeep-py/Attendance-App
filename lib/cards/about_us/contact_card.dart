import 'package:flutter/material.dart';
import '../../models/about_us.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCard extends StatelessWidget {
  final AboutUs aboutUs;
  const ContactCard({required this.aboutUs, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(Iconsax.user, color: Colors.black, size: 28),
              ),
              const SizedBox(width: 12),
              const Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE0E0E0), thickness: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _iconButton(
                Iconsax.call,
                'Call',
                () => _launch('tel:${aboutUs.phone}'),
                Colors.black,
              ),
              _iconButton(
                Iconsax.sms,
                'Email',
                () => _launch('mailto:${aboutUs.email}'),
                Colors.black,
              ),
              _iconButton(
                Iconsax.location,
                'Location',
                () => _launchMap(aboutUs.address),
                Colors.black,
              ),
              _iconButton(
                Iconsax.global,
                'Website',
                () => _launch(aboutUs.website),
                Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton(
    IconData icon,
    String label,
    VoidCallback onTap,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, size: 28, color: Colors.black),
          ),
        ),
        const SizedBox(height: 6),
         Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Future<void> _launch(String url) async {
    Uri uri = Uri.parse(url);

    // Chrome
    if (url.contains('http') || url.contains('https')) {
      final chromeUri = Uri.parse('googlechrome://$url');
      if (await canLaunchUrl(chromeUri)) {
        await launchUrl(chromeUri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    // Email
    if (url.startsWith('mailto:')) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    // Phone
    if (url.startsWith('tel:')) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    // Fallback: open in browser
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchMap(String address) async {
    final encoded = Uri.encodeComponent(address);
    final googleMapsUrl = 'geo:0,0?q=$encoded';
    final googleMapsWebUrl =
        'https://www.google.com/maps/search/?api=1&query=$encoded';
    final geoUri = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(geoUri)) {
      await launchUrl(geoUri, mode: LaunchMode.externalApplication);
    } else {
      await _launch(googleMapsWebUrl);
    }
  }
}
