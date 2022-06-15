part of zwap_modal;

class NewModalMultiStepWidget extends StatefulWidget {
  /// This field will update automatically when its value change,
  /// animating the body widget.
  final int currentStep;

  /// The ORDERED list of widget to display
  final List<Widget> children;

  /// This value is used to limit the viewport of the PageView
  /// which will normally throw exception instead
  final double heigth;

  const NewModalMultiStepWidget({
    required this.children,
    required this.currentStep,
    required this.heigth,
    Key? key,
  }) : super(key: key);

  @override
  State<NewModalMultiStepWidget> createState() => _NewModalMultiStepWidgetState();
}

class _NewModalMultiStepWidgetState extends State<NewModalMultiStepWidget> {
  final PageController _pageController = PageController();

  @override
  void didUpdateWidget(covariant NewModalMultiStepWidget oldWidget) {
    print(widget.currentStep != _pageController.page);
    if (widget.currentStep != _pageController.page)
      _pageController.animateToPage(
        widget.currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.decelerate,
      );
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.heigth,
      child: PageView(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        children: widget.children,
      ),
    );
  }
}
