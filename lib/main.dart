import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'screens/customize_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/room_screen.dart';
import 'screens/store_screen.dart';
import 'state/app_state.dart';
import 'theme/colors.dart';
import 'theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.lavender200,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.cream,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const SplitsApp());
}

class SplitsApp extends StatelessWidget {
  const SplitsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Splits Quest',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        initialRoute: '/customize',
        routes: {
          '/customize': (_) => const CustomizeScreen(isInitialSetup: true),
          '/room': (_) => const RoomScreen(),
          '/progress': (_) => const ProgressScreen(),
          '/store': (_) => const StoreScreen(),
          '/inventory': (_) => const InventoryScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/customize-edit') {
            return MaterialPageRoute(
              builder: (_) => const CustomizeScreen(isInitialSetup: false),
            );
          }
          return null;
        },
      ),
    );
  }
}
