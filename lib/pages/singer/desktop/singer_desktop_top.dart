import 'package:flutter/material.dart';
import 'package:dovemusic/entity/singer_entity.dart';
import 'package:dovemusic/manager/audio_manager.dart';
import 'package:dovemusic/widget/filtered_widget.dart';
import 'package:dovemusic/widget/placeholder_image.dart';
import 'package:dovemusic/widget/play_all_button.dart';

/// @Author: gstory
/// @CreateDate: 2023/6/19 14:19
/// @Email gstory0404@gmail.com
/// @Description: dart类作用描述

class SingerDesktopTop extends StatelessWidget {
  SingerEntity? entity;

  SingerDesktopTop({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 110,
          child: FilteredWidget(
            child: PlaceholderImage(
              width: MediaQuery.of(context).size.width,
              height: 110,
              image: entity?.picture ?? "",
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          height: 140,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlaceholderImage(
                width: 120,
                height: 120,
                image: entity?.picture ?? "",
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entity?.name ?? "",
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    Container(height: 2),
                    Expanded(child: Container()),
                    PlayAllButton(
                      onTap: () {
                        AudioManager.instance.setList(entity?.list ?? [], 0);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
