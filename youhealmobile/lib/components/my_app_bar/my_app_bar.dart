import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/utils/resources.dart';
import 'package:youhealmobile/view_model/my_posts_view_model.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  // final String screenTitle;
  const MyAppBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    return Consumer<MyPostsViewModel>(
      builder: (context, viewModel, _) => AppBar(
        
        title: Container(
          height: 50,
          width: 100,
          decoration: BoxDecoration(
            // color: Colors.white,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(Resources.appLogo),
            ),
          ),
        ),
        actions: [
          if (viewModel.postEdit['id'] != -1)
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.done),
              label: const Text("done"),
            ),
        ],
      ),
    );
  }
}
