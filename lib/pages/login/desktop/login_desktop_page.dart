import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:larkmusic/generated/l10n.dart';
import 'package:larkmusic/pages/home/home_page.dart';
import 'package:larkmusic/pages/login/login_provider.dart';
import 'package:larkmusic/utils/sp/sp_manager.dart';
import 'package:larkmusic/utils/toast/toast_util.dart';
import 'package:larkmusic/widget/background_widget.dart';
import 'package:larkmusic/widget/ink_widget.dart';
import 'package:larkmusic/widget/input_widget.dart';

/// @Author: gstory
/// @CreateDate: 2023/5/24 15:11
/// @Email gstory0404@gmail.com
/// @Description: dart类作用描述

class LoginDesktopPage extends ConsumerStatefulWidget {
  LoginDesktopPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return LoginDesktopPageState();
  }
}

class LoginDesktopPageState extends ConsumerState<LoginDesktopPage> {
  @override
  void initState() {
    super.initState();
    if(SPManager.instance.getUserInfo().token?.isNotEmpty ?? false){
      HomePage.go(context);
    }
    WidgetsBinding.instance.addPostFrameCallback((mag) {
      ref.watch(loginProvider.notifier).readCacheData();
      ref.watch(loginProvider.notifier).addListener((state) {
        if (state.loginEntity != null && state.loginEntity?.userId != 0) {
          ToastUtils.show(S.current.loginSuccess);
          HomePage.go(context);
        } else if (state.errMsg != null) {
          ToastUtils.show("${state.errMsg}");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(loginProvider);
    return Scaffold(
      body: Stack(
        children: [
          BackGroundWidget(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.current.appName,
                    style: TextStyle(
                        fontSize: 26,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontFamily: 'RobotoMono'),
                  ),
                  const SizedBox(height: 100),
                  kIsWeb
                      ? Container()
                      : InputWidget(
                          lable: S.current.serviceUrl,
                          text: model.url,
                          icon: const Icon(Icons.network_check),
                          minWidth: 400,
                          maxWidth: 400,
                          maxLength: 100,
                          maxLines: 1,
                          afterEdit: (data) {
                            ref.watch(loginProvider.notifier).setHost(data);
                          },
                        ),
                  const SizedBox(height: 20),
                  InputWidget(
                    lable: S.current.account,
                    text: model.account,
                    icon: const Icon(Icons.people),
                    minWidth: 400,
                    maxWidth: 400,
                    maxLines: 1,
                    afterEdit: (data) {
                      ref.watch(loginProvider.notifier).setAccount(data);
                    },
                  ),
                  const SizedBox(height: 20),
                  InputWidget(
                    lable: S.current.password,
                    text: model.password,
                    icon: const Icon(Icons.verified_user),
                    minWidth: 400,
                    maxWidth: 400,
                    maxLines: 1,
                    afterEdit: (data) {
                      ref.watch(loginProvider.notifier).setPassword(data);
                    },
                  ),
                  const SizedBox(height: 60),
                  InkWidget(
                    //在最外层包裹InkWell组件
                    onTap: () async {
                      if (model.url.isEmpty) {
                        ToastUtils.show(S.current.serviceUrlNotEmpty);
                        return;
                      }
                      if (model.account.isEmpty) {
                        ToastUtils.show(S.current.accountNotEmpty);
                        return;
                      }
                      if (model.password.isEmpty) {
                        ToastUtils.show(S.current.passwordNotEmpty);
                        return;
                      }
                      ref.read(loginProvider.notifier).login();
                    },
                    radius: 30.0,
                    child: Container(
                      width: 300,
                      height: 50,
                      child: Center(
                        child: Text(
                          S.current.login,
                          style: TextStyle(
                              fontSize: 14,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
