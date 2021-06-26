/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

/// Custom widget to retrieve custom data with a fetch API on FutureBuilder
class CustomFutureProvider<T> extends StatelessWidget{

  /// Callback function to retrieve the data with a custom fetch API
  final Function(BuildContext context) callBackFetch;

  /// Initial data to set while waiting the data from the fetch API
  final dynamic initialData;

  /// The child widget to display inside
  final Widget child;

  /// The optional waiting widget
  final Widget? waitChildWidget;

  CustomFutureProvider({Key? key,
    required this.callBackFetch,
    required this.initialData,
    required this.child,
    this.waitChildWidget
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureProvider<T>(
      create: (_) {
        // print('calling future');
        return this.callBackFetch(context);
      },
      initialData: this.initialData,
      child: Consumer<T>(
        builder: (_, value, __) => value != null ?  this.child : this.waitChildWidget ?? Container(),
      ),
    );
  }

}