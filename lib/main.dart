import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ui.dart';
import 'blocs/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    // Observe state changes
    blocObserver: SimpleBlocObserver(),
  );
}
