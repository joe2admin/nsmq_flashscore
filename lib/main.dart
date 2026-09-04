import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Disallow HTTP runtime fetching so all Google Fonts are served from local bundled assets.
  GoogleFonts.config.allowRuntimeFetching = false;

  LicenseRegistry.addLicense(() async* {
    final String license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(<String>['google_fonts'], license);
  });

  runApp(const NsmqFlashscoreApp());
}

class NsmqFlashscoreApp extends StatelessWidget {
  const NsmqFlashscoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NSMQ Flashscore',
      debugShowCheckedModeBanner: false,
      theme: NeoTheme.lightTheme,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.rightToLeftWithFade,
    );
  }
}
