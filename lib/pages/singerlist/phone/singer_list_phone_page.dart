import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:larkmusic/pages/singerlist/desktop/singer_list_desktop_item.dart';
import 'package:larkmusic/pages/singerlist/singer_list_provider.dart';
import 'package:larkmusic/widget/background_widget.dart';
import 'package:larkmusic/widget/status_widget.dart';

import '../../../generated/l10n.dart';

/// @Author: gstory
/// @CreateDate: 2023/11/10 16:09
/// @Email gstory0404@gmail.com
/// @Description: dart类作用描述

class SingerListPhonePage extends ConsumerWidget {
  const SingerListPhonePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(singerListProvider);
    return BackGroundWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.current.singer),
        ),
        backgroundColor: Colors.white60,
        body: StatusWidget(
            status: model.status,
            child: Container(
              child: EasyRefresh(
                controller: model.controller,
                triggerAxis: Axis.vertical,
                onRefresh: () {
                  ref.read(singerListProvider.notifier).refreshPage();
                },
                onLoad: () {
                  ref.read(singerListProvider.notifier).loadMorePage();
                },
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1, //子widget宽高比例
                  ),
                  itemCount: model.singerList.length,
                  itemBuilder: (context, index) {
                    return SingerListDesktopItem(
                      entity: model.singerList[index],
                    );
                  },
                ),
              ),
            )),
      ),
    );
  }
}
