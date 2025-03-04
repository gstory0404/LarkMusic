import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:dovemusic/generated/l10n.dart';
import 'package:dovemusic/manager/audio_manager.dart';
import 'package:dovemusic/manager/locale_provider.dart';
import 'package:dovemusic/routes/app_pages.dart';
import 'package:dovemusic/theme/theme_main.dart';
import 'package:dovemusic/utils/sp/sp_manager.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initWindow();
  initAudio();
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

void initWindow() async {
  if (kIsWeb) {
  } else if (Platform.isFuchsia || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      // 隐藏窗口标题栏
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
      await windowManager.setSize(const Size(960, 700));
      await windowManager.setMinimumSize(const Size(1080, 700));
      await windowManager.center();
      await windowManager.show();
      await windowManager.setSkipTaskbar(false);
    });
  } else if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  //隐藏域名中"#"
  if (kIsWeb) {
    setPathUrlStrategy();
  }
}

void initAudio() async {
  if (!kIsWeb) {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.gstory.dovemusic',
      androidNotificationChannelName: 'Dove Music',
      androidNotificationOngoing: true,
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OKToast(
      child: MaterialApp.router(
        key: navigatorKey,
        title: "DoveMusic",
        onGenerateTitle: (context) {
          return "DoveMusic";
        },
        //路由
        routerConfig: (kIsWeb ||
                Platform.isFuchsia ||
                Platform.isWindows ||
                Platform.isMacOS ||
                Platform.isLinux)
            ? desktopRouter
            : phoneRouter,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: S.delegate.supportedLocales[
            ref.watch(localeProvider.select((value) => value))],
        theme: themeMain,
      ),
    );
  }
}
