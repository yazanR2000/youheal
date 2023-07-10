
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/utils/enums.dart';
import 'package:youhealmobile/view_model/auth_view_model.dart';

class HeaderContainer extends StatelessWidget {
  const HeaderContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      height: screenSize.height * 0.25,
      width: screenSize.width,
      child: Stack(
        children: [
          // Container(
          //   decoration: ShapeDecoration(
          //       shape: MessageBorder(screenHeight: screenSize.height),
          //       shadows: [
          //         BoxShadow(
          //             color: Color(0xffA84141AD).withOpacity(0.2),
          //             blurRadius: 40,
          //             spreadRadius: 10,
          //             offset: Offset(0, 3)),
          //       ]),
          // ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 50),
            alignment: Alignment.bottomCenter,
            height: screenSize.height * 0.25,
            width: screenSize.width,
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     stops: const [0, 0, 1, 0],
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     colors: Constants.headerContainerColors,
            //   ),
            // ),
            child: Hero(
              tag: 'logo',
              child: Image(
                width: screenSize.width * 0.4,
                 height: screenSize.height * 0.1,
                image: const AssetImage('assets/images/logo.png'),
              ),
            ),
          ),
          Consumer<AuthViewModel>(
            builder: (context, authProvider, _) => Positioned(
              top: screenSize.height * 0.08,
              left: 10,
              child: AnimatedOpacity(
                opacity: authProvider.authType == AuthType.login ? 0 : 1,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.linear,
                child: IconButton(
                  onPressed: (authProvider.authType == AuthType.signup ||
                              authProvider.authType == AuthType.reset) &&
                          !authProvider.isLoadingForAuth
                      ? () => authProvider.changeAuthType(AuthType.login)
                      : null,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: const Color(0xff929497),
                  disabledColor: const Color(0xff929497),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  final double screenHeight;

  CustomClipPath({required this.screenHeight});
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.5);
    path.quadraticBezierTo(
        size.width * 0.5, screenHeight * 0.4, size.width, size.height * 0.5);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MessageBorder extends ShapeBorder {
  final bool usePadding;
  final double screenHeight;

  const MessageBorder({this.usePadding = true, required this.screenHeight});

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.only(bottom: usePadding ? 20 : 0);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    // rect = Rect.fromPoints(rect.topLeft, rect.bottomRight - Offset(0, 20));
    final size = rect.size;
    return Path()
      ..lineTo(0, size.height * 0.7)
      ..quadraticBezierTo(
          size.width * 0.5, screenHeight * 0.4, size.width, size.height * 0.7)
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    // TODO: implement getInnerPath
    throw UnimplementedError();
  }
}
