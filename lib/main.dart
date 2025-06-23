import 'package:and_drum_pad_flutter/service_locator/service_locator.dart';
import 'package:and_drum_pad_flutter/view/my_application.dart';
import 'package:and_drum_pad_flutter/view/screen/home/home_screen.dart';
import 'package:and_drum_pad_flutter/view_model/locale_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ServiceLocator.instance.initialise();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocateViewModel()),
      ],
      child: const MyApplication(),
    ),
  );
}
