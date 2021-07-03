/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

typedef ElementChild<T> = Widget Function(Consumer<T> consumer);

/// The custom provider to setup a dynamic state with the provide
class ProviderCustomer<T extends ChangeNotifier> extends StatelessWidget{

  /// The child widget inside this provider state
  final Widget Function(T element) childWidget;

  /// Custom widget function to get the consumer and display inside the parent widget
  final ElementChild<T> elementChild;

  ProviderCustomer({Key? key,
    required this.childWidget,
    required this.elementChild,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    T _viewModel = GetIt.instance.get<T>();
    return ChangeNotifierProvider<T>(
        create: (context) => _viewModel,
        child: this.elementChild(Consumer<T>(
            builder: (context, provider, child){
              return this.childWidget(provider);
            }
        ))
    );
  }

}