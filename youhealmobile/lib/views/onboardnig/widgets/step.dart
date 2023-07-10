import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StepWidget extends StatelessWidget {
  final String image;
  final bool isVisible;
  final String mainText;
  final String secondryText;
  const StepWidget({super.key, 
    required this.image,
    required this.isVisible,
    required this.mainText,
    required this.secondryText,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1 : 0,
      duration: const Duration(milliseconds: 800),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (image.contains('.svg')) SvgPicture.asset(image),
          if (!image.contains('.svg')) Image(image: AssetImage(image)),
          const SizedBox(height: 20,),
          Text(
            mainText,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: const Color(0xff333348),
                ),
          ),
          Text(
            secondryText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: const Color(0xff333348),
                ),
          ),
        ],
      ),
    );
  }
}
