import 'package:flutter/material.dart';

// Color palette (updated)
const Color kBlack = Colors.black;
const Color kBrown = Color(0xFF554E3E); // new brown shade
const Color kGreen = Color.fromARGB(255, 61, 61, 60); // new green shade
const Color kPink = Color.fromARGB(255, 0, 0, 0); // new pink shade
const Color kWhite = Colors.white;
const Color kWhiteGrey = Color(0xFFF5F5F7); // keep for backgrounds if needed
const Color kerror = Color.fromARGB(255, 186, 14, 14); // Error Color

// Additional colors for UI consistency
const Color kPrimary = Color(0xFF3B82F6); // Example blue primary
const Color kGrey = Color(0xFFB0B0B0); // Neutral grey
const Color kText = Color(0xFF222222); // Main text color

// Extreme minimum screen padding for modern Android smartphones
const double kScreenPadding = 8.0;

// Font family from pubspec.yaml
const String kFontFamily = 'BricolageGrotesque';

// Text styles (updated for new palette)
const TextStyle kHeaderTextStyle = TextStyle(
  fontFamily: kFontFamily,
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: kBrown,
  letterSpacing: 0.5,
);

const TextStyle kTaglineTextStyle = TextStyle(
  fontFamily: kFontFamily,
  fontSize: 18,
  fontWeight: FontWeight.w500,
  color: kGreen,
  letterSpacing: 0.2,
);

const TextStyle kCaptionTextStyle = TextStyle(
  fontFamily: kFontFamily,
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: kBrown,
);

// Body text style for cards and details
const TextStyle kBodyTextStyle = TextStyle(
  fontFamily: kFontFamily,
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: kText,
);

const TextStyle kDescriptionTextStyle = TextStyle(
  fontFamily: kFontFamily,
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: kPink,
);

// Button style (updated)
final ButtonStyle kPremiumButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: kGreen,
  foregroundColor: kWhite,
  minimumSize: const Size(120, 48),
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  textStyle: const TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  ),
  elevation: 4,
);

// App logo widget (example)
class AppLogo extends StatelessWidget {
	final double size;
	final String assetPath;
	const AppLogo({
		this.size = 48,
		this.assetPath = 'assets/logo/naiyo24_logo.png',
		super.key,
	});

	@override
	Widget build(BuildContext context) {
		return Container(
			width: size,
			height: size,
			decoration: BoxDecoration(
				shape: BoxShape.circle,
				gradient: const LinearGradient(
					colors: [kWhite, kWhite],
					begin: Alignment.topLeft,
					end: Alignment.bottomRight,
				),
				boxShadow: [
					BoxShadow(
						color: kWhiteGrey.withAlpha(51),
						blurRadius: 8,
						offset: const Offset(0, 4),
					),
				],
			),
			child: Center(
				child: Image.asset(
					assetPath,
					width: size * 0.6,
					height: size * 0.6,
					fit: BoxFit.contain,
				),
			),
		);
	}
}

// ThemeData (updated)
final ThemeData appTheme = ThemeData(
  fontFamily: kFontFamily,
  scaffoldBackgroundColor: kWhite,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: kBrown,
    onPrimary: kWhite,
    secondary: kGreen,
    onSecondary: kWhite,
    surface: kWhiteGrey,
    onSurface: kBrown,
    error: kPink,
    onError: kWhite,
  ),
  textTheme: TextTheme(
    displayLarge: kHeaderTextStyle,
    titleLarge: kTaglineTextStyle,
    bodySmall: kCaptionTextStyle,
    bodyMedium: kDescriptionTextStyle,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: kPremiumButtonStyle,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kWhiteGrey,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    hintStyle: TextStyle(
      color: kBrown,
      fontFamily: kFontFamily,
    ),
  ),
);
