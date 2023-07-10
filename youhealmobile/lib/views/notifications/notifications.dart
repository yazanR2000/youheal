import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/components/custom_scaffold.dart';
import 'package:youhealmobile/components/spinkit.dart';
import 'package:youhealmobile/utils/resources.dart';
import 'package:youhealmobile/view_model/notifications_view_model.dart';

import '../../components/screen_header_box.dart';
import '../../utils/app_colors.dart';
import 'widgets/notifications_tiles.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<NotificationsViewModel>(context, listen: false)
          .getNotificationByUserId(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return CustomScaffold(
      body: Consumer<NotificationsViewModel>(
        builder: (context, viewModel, _) => viewModel.isLoading
            ? Center(
                child: Spinkit.spinKit(),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await Provider.of<NotificationsViewModel>(context,
                          listen: false)
                      .getNotificationByUserId(context: context);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    vertical: screenSize.height * 0.15,
                    horizontal: screenSize.width * 0.06,
                  ),
                  child: Column(
                    children: [
                      ScreenHeaderBox(
                        imagePath: Resources.notificationsIcon,
                        icon: Icons.notifications,
                        title: "notifications",
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      NotificationsTiles(tiles: viewModel.notifications),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
