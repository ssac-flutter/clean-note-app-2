import 'package:clean_note_app_2/di/di_setup.dart';
import 'package:clean_note_app_2/presentation/notes/notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'util/color_scheme.dart';

void main() async {
  // 플랫폼 채널의 위젯 바인딩을 보당함.
  WidgetsFlutterBinding.ensureInitialized();

  // 의존성 수정은 di에서 하면 됨
  // final providers = await getProviders();
  // runApp(
  //   MultiProvider(
  //     providers: providers,
  //     child: const MyApp(),
  //   ),
  // );

  // injectable 사용
  // await setupDi();
  await configureDependencies();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
      ),
      themeMode: ThemeMode.system,
      home: const NotesScreen(),
    );
  }
}
