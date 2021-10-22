import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import "package:locadeserta/main_class.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  runApp(LocaDesertaApp());
}
