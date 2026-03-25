import 'package:flutter_riverpod/legacy.dart';
import '../models/about_us.dart';

class AboutUsNotifier extends StateNotifier<AboutUs> {
  AboutUsNotifier()
      : super(
          AboutUs(
            companyName: 'Attendx24',
            tagline: 'Where Innovation meets Business!',
            logoPath: 'assets/logo/A24.png',
            description: 'We are a startup based in Kolkata, focused on providing innovative solutions for modern medical needs. Our mission is to make HRMS accessible, efficient, and reliable for everyone. We combine technology and compassion to deliver the best experience to our clients and partners.',
            directorName: 'Mr. Debasish Baidya',
            directorMessage: 'At Attendx24, we believe in the power of technology to transform lives. Our commitment is to bring the best HRMS solutions to your fingertips, ensuring quality and care in every interaction.',
            directorImagePath: 'assets/logo/director.jpeg',
            phone: '+91 62891 71798',
            email: 'info@attendx24.com',
            address: '1/30 Chittaranjan Colony, Baghajatin, Kolkata - 700032',
            website: 'https://attendx24.com',
          ),
        );
}
