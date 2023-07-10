import 'package:flutter/material.dart';
import 'package:youhealmobile/views/post_comments/post_comments.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/navigator.dart';
import '../../languages/languages.dart';

class NotificationsTiles extends StatelessWidget {
  final List<dynamic> tiles;
  const NotificationsTiles({super.key,required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 0),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ListView.builder(
        itemCount: tiles.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) => Tile(
          leadingIcon: Icons.notifications_none_rounded,
          title: tiles[index]['title'],
          subtitle: tiles[index]['body'],
          navigateScreen: PostComments(postId: tiles[index]['postId']),
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final IconData leadingIcon;
  final String title,subtitle;
  final Widget navigateScreen;
  const Tile({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.navigateScreen,
    required this.subtitle
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onTap: () => NavigationController.navigatorRoute(
        context: context,
        page: navigateScreen,
      ),
      leading: Icon(
        leadingIcon,
        color: AppColors.primaryColor,
        size: 30,
      ),
      title: Text(title,style: Theme.of(context).textTheme.bodyMedium,),
      subtitle: Text(subtitle),
      dense: true,
      trailing: Icon(
        Icons.arrow_right_rounded,
        color: AppColors.primaryColor,
      ),
    );
  }
}
