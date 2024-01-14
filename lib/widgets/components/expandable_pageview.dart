import 'package:flutter/material.dart';
import 'package:workout_routine/widgets/components/size_reporting_widget.dart';

class ExpandablePageView extends StatefulWidget {
  final List<Widget> children;

  const ExpandablePageView({super.key, required this.children});

  @override
  State<ExpandablePageView> createState() => _ExpandablePageViewState();
}

class _ExpandablePageViewState extends State<ExpandablePageView> {
  late PageController _pageController;
  late List<double> _heights;
  int _currentPage = 0;

  double get _currentHeight => _heights[_currentPage];

  @override
  void initState() {
    _heights = widget.children.map((e) => 0.0).toList();

    super.initState();

    _pageController = PageController()
      ..addListener(() {
        final newPage = _pageController.page?.round() ?? 0;
        if (_currentPage != newPage) {
          setState(() => _currentPage = newPage);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _currentHeight,
      child: PageView(
        controller: _pageController,
        children: widget.children
            .asMap()
            .map((index, child) => MapEntry(
                  index,
                  SizeReportingWidget(
                    onSizeChange: (size) => setState(() => _heights[index] = size.height),
                    child: child,
                  ),
                ))
            .values
            .toList(),
      ),
    );
  }
}
