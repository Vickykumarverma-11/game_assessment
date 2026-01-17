import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/game_local_data_source.dart';
import 'presentation/bloc/game_bloc.dart';
import 'presentation/bloc/game_event.dart';
import 'presentation/screens/game_screen.dart';
import 'presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final dataSource = GameLocalDataSource(prefs);

  runApp(MyApp(dataSource: dataSource));
}

class MyApp extends StatelessWidget {
  final GameLocalDataSource dataSource;

  const MyApp({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: BlocProvider(
        create: (context) => GameBloc(dataSource)..add(const StartGame()),
        child: const GameScreen(),
      ),
    );
  }
}
