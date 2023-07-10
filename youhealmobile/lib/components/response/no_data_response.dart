import 'package:flutter/material.dart';

class NoDataResponse extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String buttonText;
  const NoDataResponse(
      {super.key, required this.onPressed, required this.title,required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              OutlinedButton(
                onPressed: onPressed,
                child: Text(
                  buttonText
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
