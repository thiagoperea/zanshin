import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print("CUBIT: [ ${bloc.runtimeType} ] | STATE: ${change.nextState}");
    print("-----------------------------------------------------------");
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print("CUBIT: [ ${bloc.runtimeType} ] | STATE: ${bloc.state}");
    print("-----------------------------------------------------------");
  }
}
