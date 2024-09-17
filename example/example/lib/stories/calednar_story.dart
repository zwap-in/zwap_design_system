import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _CalendarProvider extends ChangeNotifier {
  _CalendarProvider() : super();
}

class CalendarStoryWidget extends StatelessWidget {
  const CalendarStoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<_CalendarProvider>(
      create: (_) => _CalendarProvider(),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xff000025),
      ),
    );
  }
}
