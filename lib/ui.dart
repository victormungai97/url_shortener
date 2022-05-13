import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/model.dart' show Links;

import 'controllers/controller.dart';
import 'navigation/navigator.dart';
import 'blocs/bloc.dart';
import 'constants.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: ChangeNotifierProvider(
        child: MaterialApp.router(
          theme: ThemeData(
            primarySwatch: materialPrimaryColor,
            textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
          ),
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          debugShowCheckedModeBanner: false,
          title: title,
        ),
        create: (_) => Links(),
      ),
      create: (_) => LinkBloc(LinkController()),
    );
  }
}
