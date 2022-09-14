import 'dart:io';

import 'package:assessment/env/prod.dart';
import 'package:assessment/model_classes/app_config_env.dart';
import 'package:assessment/provider/app_provider.dart';
import 'package:assessment/provider/text_form_provider.dart';
import 'package:assessment/ui/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

main({String env = "dev"}) async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    /* Initialize environment variables on basis on [main_dev] && [main_prod] classes*/
    AppConfigEnv.fromJson(configPro);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => TextFormProvider()),
        ],
        child: ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (BuildContext context, Widget? child) {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Digital14 Assessment',
                home: child,
              );
            },
            child: const SplashScreen()));
  }
}
