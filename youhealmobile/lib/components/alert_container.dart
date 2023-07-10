import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AlertContainer extends StatefulWidget {
  final Color backgroundColor;
  final String content;
  final List<String>? points;
  final Color? textColor;
  final Function? onPressed;
  const AlertContainer(
      {super.key,
      required this.backgroundColor,
      required this.content,
      this.onPressed,
      this.textColor,
      this.points});

  @override
  State<AlertContainer> createState() => _AlertContainerState();
}

class _AlertContainerState extends State<AlertContainer> {
  bool _showFirst = true;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      crossFadeState:
          _showFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: Container(
        constraints: BoxConstraints(maxHeight: screenSize.height * 0.4),
        margin: const EdgeInsets.only(bottom: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.backgroundColor.withOpacity(0.65),
          borderRadius: BorderRadius.circular(5),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 5,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.horizontal(
                    right: context.locale == const Locale('ar', 'EG')
                        ? const Radius.circular(5)
                        : Radius.zero,
                    left: context.locale != const Locale('ar', 'EG')
                        ? const Radius.circular(5)
                        : Radius.zero,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Icon(
                MdiIcons.alertCircle,
                color: Colors.amber,
              ),
              const SizedBox(
                width: 8,
              ),
              if (widget.points != null)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        ...widget.points!
                            .map(
                              (e) => Column(
                                children: [
                                  Text(
                                    '- $e',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          fontSize: 12,
                                          color: widget.textColor ??
                                              const Color(0xff95989A),
                                        ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ),
              if (widget.points == null)
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.content,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: 12,
                                  color: widget.textColor ??
                                      const Color(0xff95989A),
                                ),
                          ),
                          widget.onPressed == null
                              ? Text(
                                  tr("newReadingAdded"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          fontSize: 12,
                                          color: widget.textColor ??
                                              const Color(0xff95989A),
                                          fontWeight: FontWeight.bold),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              widget.onPressed != null
                  ? TextButton(
                      onPressed: () {
                        setState(() {
                          _showFirst = !_showFirst;
                          widget.onPressed!();
                        });
                      },
                      child: Text(
                        tr('accept'),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
      secondChild: const SizedBox(),
    );
  }
}
