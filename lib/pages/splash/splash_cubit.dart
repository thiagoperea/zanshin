import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zanshin/data/model/task.dart';
import 'package:zanshin/pages/app_settings/app_settings_cubit.dart';
import 'package:zanshin/utility/simple_bloc_observer.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashLoading());

  Future<void> loadResources(AppSettingsCubit settingsCubit) async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());

    await settingsCubit.loadSettings();

    if (kDebugMode) {
      BlocOverrides.runZoned(
        () => {},
        blocObserver: SimpleBlocObserver(),
      );
    }

    emit(SplashLoaded());
  }
}
