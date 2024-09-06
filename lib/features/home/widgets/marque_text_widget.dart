import 'package:flutter/material.dart';

class MarqueeWidget extends StatefulWidget {
  final Widget child;
  final Axis direction;
  final Duration animationDuration, pauseDuration;
  const MarqueeWidget({
    super.key,
    required this.child,
    this.direction = Axis.horizontal,
    this.animationDuration = const Duration(milliseconds: 20000),
    this.pauseDuration = const Duration(milliseconds: 0),
  });

  @override
  MarqueeWidgetState createState() => MarqueeWidgetState();
}

class MarqueeWidgetState extends State<MarqueeWidget> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController(initialScrollOffset: 0.0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startScrolling();
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: widget.direction,
      controller: scrollController,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.child,
          SizedBox(
            width: widget.direction == Axis.horizontal ? 20.0 : 0.0,
            height: widget.direction == Axis.vertical ? 20.0 : 0.0,
          ),
          widget.child,
        ],
      ),
    );
  }

  void startScrolling() async {
    while (scrollController.hasClients) {
      await Future.delayed(widget.pauseDuration);
      if (scrollController.hasClients) {
        final maxScrollExtent = scrollController.position.maxScrollExtent;
        await scrollController.animateTo(
          maxScrollExtent,
          duration: const Duration(milliseconds: 15000),
          curve: Curves.linear,
        );
        if (scrollController.hasClients) {
          scrollController.jumpTo(0.0);
        }
      }
    }
  }
}
