import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:youhealmobile/utils/navigator.dart';


class CardButton extends StatelessWidget {
  final String title;
  final String icon;
  final Widget page;
  const CardButton({
    super.key,
    required this.icon,
    required this.page,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () =>
            NavigationController.navigatorRoute(context: context, page: page),
        child: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          // height: ,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.35),
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 0),
                color: Colors.black12,
                blurRadius: 30,
                spreadRadius: 5,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // color: AppColors.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Image(image: AssetImage(icon),height: 50,width: 50,),
              ),
              Text(
                tr(title),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.black,fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
