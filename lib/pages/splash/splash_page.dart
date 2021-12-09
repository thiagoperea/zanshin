import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanshin/pages/app_settings/app_settings_cubit.dart';
import 'package:zanshin/pages/home_page.dart';
import 'package:zanshin/pages/splash/splash_cubit.dart';

class SplashPage extends StatefulWidget {
  static const String route = '/';

  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashCubit _cubit = SplashCubit();

  @override
  void initState() {
    final _settingsCubit = context.read<AppSettingsCubit>();
    _cubit.loadResources(_settingsCubit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashCubit>(
      create: (context) => _cubit,
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashLoaded) {
            Navigator.popAndPushNamed(context, HomePage.route);
          }
        },
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
