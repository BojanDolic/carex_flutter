import 'package:carex_flutter/services/bloc/blocs/vehicles_bloc.dart';
import 'package:carex_flutter/services/bloc/events/vehicles_bloc_events.dart';
import 'package:carex_flutter/services/preferences/preferences.dart';
import 'package:carex_flutter/services/repositories/repository.dart';
import 'package:carex_flutter/services/store/objectbox_store.dart';
import 'package:carex_flutter/ui/router.dart';
import 'package:carex_flutter/ui/screens/mycar_screen.dart';
import 'package:carex_flutter/ui/widgets/settings_provider.dart';
import 'package:carex_flutter/util/constants/color_constants.dart';
import 'package:carex_flutter/util/constants/text_style_constants.dart';
import 'package:carex_flutter/util/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

late ObjectBox objectBox;
late SharedPreferences preferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectBox = await ObjectBox.create();
  preferences = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsProvider(
      preferences: UserPreferences(preferences),
      child: RepositoryProvider(
        create: (BuildContext context) => Repository(objectBox),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<VehiclesBloc>(
              create: (context) => VehiclesBloc(
                RepositoryProvider.of(context),
              )..add(
                  LoadVehicles(
                    vehicles: RepositoryProvider.of<Repository>(context).getAllVehicles(),
                  ),
                ),
            ),
          ],
          child: MaterialApp(
            title: 'Carex',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: mainColorLight,
              colorScheme: const ColorScheme(
                brightness: Brightness.light,
                primary: mainColorLight,
                onPrimary: Colors.black,
                secondary: mainColorLight,
                onSecondary: Colors.white,
                error: Colors.red,
                onError: Colors.white,
                background: lightBackgroundTestColor,
                onBackground: Colors.black,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              highlightColor: mainColorLight.withOpacity(0.2),
              canvasColor: lightBackgroundTestColor,
              fontFamily: "Mulish",
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                backgroundColor: lightBackgroundTestColor,
                elevation: 0,
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
              ),
              popupMenuTheme: PopupMenuThemeData(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              textTheme: TextTheme(
                displayMedium: regularText.copyWith(color: Colors.black),
                bodyMedium: regularLightText,
                displaySmall: regularLightText.copyWith(
                  color: Colors.black,
                  fontSize: 14,
                ),
                displayLarge: regularText.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              cardTheme: CardTheme(
                color: Colors.white,
              ),
              inputDecorationTheme: InputDecorationTheme(
                enabledBorder: const OutlineInputBorder(
                  borderRadius: InterfaceUtil.allBorderRadius16,
                  borderSide: BorderSide(
                    color: borderColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: InterfaceUtil.allBorderRadius16,
                  borderSide: BorderSide(
                    color: mainColorLight,
                    width: 1.7,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: InterfaceUtil.allBorderRadius16,
                  borderSide: BorderSide(
                    color: borderColor.withOpacity(0.8),
                  ),
                ),
                floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.error)) {
                      return regularText.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      );
                    } else if (states.contains(MaterialState.focused)) {
                      return regularText.copyWith(
                        color: mainColorLight,
                        fontWeight: FontWeight.bold,
                      );
                    }
                    return regularText;
                  },
                ),
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: const ColorScheme(
                brightness: Brightness.dark,
                primary: mainColor,
                onPrimary: Colors.white,
                secondary: mainColor,
                onSecondary: Colors.white54,
                error: Colors.red,
                onError: Colors.white,
                background: darkBackgroundColor,
                onBackground: Colors.white70,
                surface: darkBackgroundColor,
                onSurface: Colors.white70,
              ),
              canvasColor: darkBackgroundColor,
              cardColor: darkCardColor,
              appBarTheme: const AppBarTheme(
                backgroundColor: darkBackgroundColor,
                elevation: 0,
                iconTheme: IconThemeData(
                  color: Colors.white70,
                ),
                titleTextStyle: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontFamily: "Mulish",
                ),
              ),
              textTheme: TextTheme(
                displayMedium: regularText.copyWith(
                  color: darkTextColor,
                ),
                bodyMedium: regularLightText,
              ),
              inputDecorationTheme: InputDecorationTheme(
                enabledBorder: const OutlineInputBorder(
                  borderRadius: InterfaceUtil.allBorderRadius16,
                  borderSide: BorderSide(
                    color: Colors.white60,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: InterfaceUtil.allBorderRadius16,
                  borderSide: BorderSide(
                    color: mainColor,
                    width: 1.7,
                  ),
                ),
                floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.error)) {
                      return regularText.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      );
                    } else if (states.contains(MaterialState.focused)) {
                      return regularText.copyWith(
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                      );
                    }
                    return regularText.copyWith(
                      color: Colors.white60,
                      fontWeight: FontWeight.bold,
                    );
                  },
                ),
              ),
            ),

            //home: MainScreen(),
            initialRoute: MyCarScreen.id,
            onGenerateRoute: generateRoutes,
            /*initialRoute: MainScreen.id,
            onGenerateRoute: generateRoutes,*/
          ),
        ),
      ),
    );
  }
}
