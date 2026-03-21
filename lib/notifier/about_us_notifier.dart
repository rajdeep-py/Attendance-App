import 'package:flutter_riverpod/legacy.dart';
import '../models/about_us.dart';

class AboutUsNotifier extends StateNotifier<AboutUs> {
  AboutUsNotifier()
      : super(
          AboutUs(
            companyName: 'Naiyo24 Pvt. Ltd.',
            tagline: 'Empowering Healthcare, Digitally',
            logoPath: 'assets/logo/naiyo24_logo.png',
            description: 'Naiyo24 Pvt. Ltd. is a leading digital healthcare company focused on providing innovative solutions for modern medical needs. Our mission is to make healthcare accessible, efficient, and reliable for everyone. We combine technology and compassion to deliver the best experience to our clients and partners.',
            directorName: 'Dr. Rajdeep Dey',
            directorMessage: 'At Naiyo24, we believe in the power of technology to transform lives. Our commitment is to bring the best healthcare solutions to your fingertips, ensuring quality and care in every interaction.',
            directorImagePath: 'assets/logo/director.jpeg',
            phone: '+91 98765 43210',
            email: 'info@naiyo24.com',
            address: '123, Digital Health Park, Kolkata, India',
            website: 'https://naiyo24.com',
            instagram: 'https://instagram.com/naiyo24',
            facebook: 'https://facebook.com/naiyo24',
            youtube: 'https://youtube.com/naiyo24',
            x: 'https://x.com/naiyo24',
          ),
        );
}
