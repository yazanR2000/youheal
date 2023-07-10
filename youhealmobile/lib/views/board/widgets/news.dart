import 'dart:async';

import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';

class News extends StatefulWidget {
  final double screenHegiht;
  final List<String> news;
  const News({super.key, required this.screenHegiht, required this.news});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  final PageController _pageController =
      PageController(viewportFraction: 0.85, initialPage: 0);
  int _currentPage = 0;

  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage != widget.news.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
      
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30,bottom: 10),
      height: widget.screenHegiht * 0.25,
      width: double.infinity,
      decoration: BoxDecoration(
        // color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: PageView.builder(
                onPageChanged: (value){
                  setState(() {
                    _currentPage = value;
                  });
                },
                controller: _pageController,
                itemBuilder: (context, index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  margin: EdgeInsets.all(index != _currentPage ? 20 : 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        widget.news[index],
                      ),
                    ),
                  ),
                ),
                itemCount: widget.news.length,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.news.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentPage
                        ? AppColors.primaryColor
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
