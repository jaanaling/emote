import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../../../routes/go_router_config.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFFFF48A0),
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            fontFamily: 'Baloo Bhaijaan',
            fontWeight: FontWeight.w400,
            fontSize: 20,
            color: Colors.black
          ),
        ),
      ),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            primaryColor: Color(0xFFFF48A0),
            textTheme: TextTheme(
              bodyLarge: TextStyle(
                fontFamily: 'Baloo Bhaijaan',
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: buildGoRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
