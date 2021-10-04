import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanshin/pages/app_settings/app_settings_cubit.dart';
import 'package:zanshin/pages/splash/splash_page.dart';
import 'package:zanshin/styles/app_themes.dart';

Future<void> main() async {
  runApp(const ZanshinApp());
}

class ZanshinApp extends StatelessWidget {
  const ZanshinApp();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppSettingsCubit>(
      create: (_) => AppSettingsCubit(),
      child: BlocBuilder<AppSettingsCubit, AppSettings>(
        builder: (context, state) => MaterialApp(
          title: 'Zanshin App',
          theme: AppThemes.lightTheme(),
          darkTheme: AppThemes.darkTheme(),
          themeMode: state.isNightMode ? ThemeMode.dark : ThemeMode.light,
          home: const SplashPage(),
        ),
      ),
    );
  }
}
