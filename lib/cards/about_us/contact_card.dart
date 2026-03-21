import 'package:flutter/material.dart';
import '../../models/about_us.dart';
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: [
          _iconButton('assets/logo/logocall_logo.jpg', () => _launch('tel:${aboutUs.phone}')),
          _iconButton('assets/logo/email_logo.jpg', () => _launch('mailto:${aboutUs.email}')),
          _iconButton('assets/logo/location_logo.jpg', () => _launchMap(aboutUs.address)),
          _iconButton('assets/logo/linkedin_logo.png', () => _launch('https://linkedin.com/company/naiyo24')),
          _iconButton('assets/logo/youtube_logo.png', () => _launch(aboutUs.youtube)),
          _iconButton('assets/logo/x_logo.png', () => _launch(aboutUs.x)),
          _iconButton('assets/logo/insta_logo.jpeg', () => _launch(aboutUs.instagram)),
          _iconButton('assets/logo/website_logo.png', () => _launch(aboutUs.website)),
          _iconButton('assets/logo/fb_logo.png', () => _launch(aboutUs.facebook)),
        ],
      ),
    );
  }

  Widget _iconButton(String assetPath, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Image.asset(assetPath, width: 8, height: 8, fit: BoxFit.contain),
      ),
    );
  }

  Future<void> _launch(String url) async {
    Uri uri = Uri.parse(url);
    // YouTube
    if (url.contains('youtube.com') || url.contains('youtu.be')) {
      final youtubeAppUri = Uri.parse(url.replaceFirst('https://', 'vnd.youtube://'));
      if (await canLaunchUrl(youtubeAppUri)) {
        await launchUrl(youtubeAppUri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    // Facebook
    if (url.contains('facebook.com')) {
      final fbAppUri = Uri.parse('fb://facewebmodal/f?href=$url');
      if (await canLaunchUrl(fbAppUri)) {
        await launchUrl(fbAppUri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    // LinkedIn
    if (url.contains('linkedin.com')) {
      final linkedInAppUri = Uri.parse('linkedin://company/naiyo24');
      if (await canLaunchUrl(linkedInAppUri)) {
        await launchUrl(linkedInAppUri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    // Instagram
    if (url.contains('instagram.com')) {
      final instaAppUri = Uri.parse('instagram://user?username=${url.split("/").last}');
      if (await canLaunchUrl(instaAppUri)) {
        await launchUrl(instaAppUri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    // X (Twitter)
    if (url.contains('x.com') || url.contains('twitter.com')) {
      final xAppUri = Uri.parse('twitter://user?screen_name=${url.split("/").last}');
      if (await canLaunchUrl(xAppUri)) {
        await launchUrl(xAppUri, mode: LaunchMode.externalApplication);
        return;
      }
    }
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
    final googleMapsWebUrl = 'https://www.google.com/maps/search/?api=1&query=$encoded';
    final geoUri = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(geoUri)) {
      await launchUrl(geoUri, mode: LaunchMode.externalApplication);
    } else {
      await _launch(googleMapsWebUrl);
    }
  }
}
