import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zanshin/data/model/task.dart';
import 'package:zanshin/pages/app_settings/app_settings_cubit.dart';
import 'package:zanshin/pages/home_page.dart';
import 'package:zanshin/styles/app_themes.dart';
import 'package:zanshin/utility/simple_bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());

  if (kDebugMode) {
    Bloc.observer = SimpleBlocObserver();
  }

  runApp(ZanshinApp());
}

class ZanshinApp extends StatefulWidget {
  const ZanshinApp({Key? key}) : super(key: key);

  @override
  State<ZanshinApp> createState() => _ZanshinAppState();
}

class _ZanshinAppState extends State<ZanshinApp> {
  final _settingsCubit = AppSettingsCubit();

  @override
  void initState() {
    _settingsCubit.loadSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppSettingsCubit>(
      create: (_) => _settingsCubit,
      child: BlocBuilder<AppSettingsCubit, AppSettings>(
        buildWhen: (previous, current) => !current.isLoading,
        builder: (context, state) => MaterialApp(
          title: 'Zanshin App',
          theme: AppThemes().lightTheme,
          darkTheme: AppThemes().darkTheme,
          themeMode: state.isNightMode ? ThemeMode.dark : ThemeMode.light,
          home: const HomePage(),
        ),
      ),
    );
  }
}
