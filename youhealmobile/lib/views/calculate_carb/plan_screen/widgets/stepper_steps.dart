import 'package:flutter/material.dart';

class StepperSteps extends StatelessWidget {
  const StepperSteps({super.key});

  @override
  Widget build(BuildContext context) {
    return Stepper(
      controlsBuilder: (context, details) => const SizedBox(),
      type: StepperType.vertical,
      physics: const NeverScrollableScrollPhysics(),
      steps: const [
        Step(
          title: Text('Day 1'),
          content: StepContent(
            content:
                'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum',
            imageUrl: 'https://images.everydayhealth.com/images/go-green-for-better-health-00-1440x810.jpg',
          ),
        ),
        Step(
          title: Text('Day 2'),
          content:  StepContent(
            content:
                'will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum',
            imageUrl: 'https://cdn.shopify.com/s/files/1/0601/5664/1470/products/stew-meat_1024x1024.jpg?v=1632858328',
          ),
        ),
        Step(
          title: Text('Day 3'),
          content: StepContent(
            content:
                'fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum',
            imageUrl: 'https://www.simplyrecipes.com/thmb/zsQvDavpqD2PtIO-7W6nBWVHCe4=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Simply-Recipes-Hard-Boiled-Eggs-LEAD-03-42506773297f4a15920c46628d534d67.jpg',
          ),
        ),
      ],
    );
  }
}

class StepContent extends StatelessWidget {
  final String content;
  final String? imageUrl;
  const StepContent({super.key, required this.content, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(content),
        if(imageUrl != null)
          const SizedBox(height: 20,),
        imageUrl == null
            ? const SizedBox()
            : Container(
                width: double.infinity,
                height: screenSize.height * 0.15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(imageUrl!),
                  ),
                ),
              ),
      ],
    );
  }
}
