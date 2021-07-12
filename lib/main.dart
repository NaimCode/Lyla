import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:social_message/controllers/cubit/settings_cubit.dart';
import 'package:social_message/home.dart';
import 'package:social_message/login.dart';
import 'package:social_message/widget/constant.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_strategy/url_strategy.dart';
import 'body.dart';
import 'controllers/cubit/chatting_cubit.dart';
import 'controllers/functions/initialisation.dart';
import 'data/internal.dart';
import 'globalVariable.dart';
import 'service/authentification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  timeago.setLocaleMessages('fr', timeago.FrMessages());
  // await Hive.openBox('Settings');
  // initHive();
  //print(FacebookAuth.i.isWebSdkInitialized);
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Authentification>(
          create: (_) => Authentification(FirebaseAuth.instance),
        ),
        // ignore: missing_required_param
        StreamProvider(
          create: (conext) => context.read<Authentification>().authStateChanges,
          initialData: null,
        ),
      ],
      child: Lyla(),
    );
  }
}

class Lyla extends StatelessWidget {
  const Lyla({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<Authentification>();
    return BlocProvider<SettingsCubit>(
      create: (context) => SettingsCubit(),
      child: BlocConsumer<SettingsCubit, SettingsState>(
          listener: (context, state) {
        // TODO: implement listener
      }, builder: (context, state) {
        return BlocProvider<ChattingCubit>(
          create: (context) => ChattingCubit(corresGlobal),
          child: GetMaterialApp(
            title: 'Lyla',
            theme: ThemeData.light().copyWith(
              textTheme: TextTheme(
                  bodyText1: GoogleFonts.rubik(
                      fontSize: 16, color: Colors.black87, wordSpacing: 2),
                  headline4: GoogleFonts.spartan(
                      fontWeight: FontWeight.bold, color: Colors.black)),
              primaryColor: state.getColor(),
            ),
            themeMode: state.getThemeMode(),
            darkTheme: ThemeData.dark().copyWith(
              textTheme: TextTheme(
                  bodyText1: GoogleFonts.rubik(
                      fontSize: 16, color: Colors.white70, wordSpacing: 2),
                  headline4: GoogleFonts.spartan(
                      fontWeight: FontWeight.bold,
                      color: ThemeData.dark().textTheme.headline4!.color)),
            ),
            home: StreamBuilder<User?>(
                stream: firebaseUser.authStateChanges,
                builder: (context, s) {
                  if (s.connectionState == ConnectionState.waiting)
                    return LoadingFullScreen();
                  if (!s.hasData)
                    return BodyLog();
                  else
                    return Provider<User?>(
                      create: (_) => s.data,
                      child: Body(),
                    );
                }),
            debugShowCheckedModeBanner: false,
          ),
        );
      }),
    );
  }
}
