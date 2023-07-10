import 'package:flutter/material.dart';
import 'package:youhealmobile/components/players/recorder_player.dart';

class CustomListViewForAudios extends StatelessWidget {
  final List<dynamic> urls;
  const CustomListViewForAudios({super.key,required this.urls});


  @override
  Widget build(BuildContext context) {
    return urls.isEmpty ? const SizedBox() : ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => RecorderPlayer(path: urls[index]),
      separatorBuilder: (context, index) => const SizedBox(height: 5,),
      itemCount: urls.length,
    );
  }
}