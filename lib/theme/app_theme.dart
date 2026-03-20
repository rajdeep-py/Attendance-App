import 'package:flutter/material.dart';

// Color palette
const Color kBlack = Color(0xFF181818);
const Color kDarkGrey = Color(0xFF232323);
const Color kGrey = Color(0xFF3A3A3A);
const Color kWhiteGrey = Color(0xFFF5F5F7);
const Color kWhite = Color(0xFFFFFFFF);

// Extreme minimum screen padding for modern Android smartphones
const double kScreenPadding = 8.0;

// Font family from pubspec.yaml
const String kFontFamily = 'BricolageGrotesque';

// Text styles
const TextStyle kHeaderTextStyle = TextStyle(
	fontFamily: kFontFamily,
	fontSize: 28,
	fontWeight: FontWeight.bold,
	color: kWhite,
	letterSpacing: 0.5,
);

const TextStyle kTaglineTextStyle = TextStyle(
	fontFamily: kFontFamily,
	fontSize: 18,
	fontWeight: FontWeight.w500,
	color: kWhiteGrey,
	letterSpacing: 0.2,
);

const TextStyle kCaptionTextStyle = TextStyle(
	fontFamily: kFontFamily,
	fontSize: 14,
	fontWeight: FontWeight.w400,
	color: kGrey,
);

const TextStyle kDescriptionTextStyle = TextStyle(
	fontFamily: kFontFamily,
	fontSize: 16,
	fontWeight: FontWeight.w400,
	color: kWhiteGrey,
);

// Button style
final ButtonStyle kPremiumButtonStyle = ElevatedButton.styleFrom(
	backgroundColor: kDarkGrey,
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
	const AppLogo({this.size = 48, super.key});

	@override
	Widget build(BuildContext context) {
		return Container(
			width: size,
			height: size,
			decoration: BoxDecoration(
				shape: BoxShape.circle,
				gradient: const LinearGradient(
					colors: [kDarkGrey, kBlack],
					begin: Alignment.topLeft,
					end: Alignment.bottomRight,
				),
				boxShadow: [
					BoxShadow(
						color: kGrey.withAlpha(51),
						blurRadius: 8,
						offset: const Offset(0, 4),
					),
				],
			),
			child: Center(
				child: Icon(
					Icons.fingerprint,
					color: kWhiteGrey,
					size: size * 0.6,
				),
			),
		);
	}
}

// ThemeData
final ThemeData appTheme = ThemeData(
	fontFamily: kFontFamily,
	scaffoldBackgroundColor: kBlack,
	colorScheme: ColorScheme(
		brightness: Brightness.dark,
		primary: kDarkGrey,
		onPrimary: kWhite,
		secondary: kGrey,
		onSecondary: kWhiteGrey,
		surface: kDarkGrey,
		onSurface: kWhiteGrey,
		error: Colors.red,
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
		fillColor: kDarkGrey,
		border: OutlineInputBorder(
			borderRadius: BorderRadius.circular(12),
			borderSide: BorderSide.none,
		),
		contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
		hintStyle: TextStyle(
			color: kGrey,
			fontFamily: kFontFamily,
		),
	),
);
