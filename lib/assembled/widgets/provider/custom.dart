/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

/// The custom provider to setup a dynamic state with the provide
class ProviderCustomer<T extends ChangeNotifier> extends StatelessWidget{

  /// The child widget inside this provider state
  final Widget Function(T element) childWidget;

  ProviderCustomer({Key? key,
    required this.childWidget
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    T _viewModel = GetIt.instance.get<T>();
    return ChangeNotifierProvider<T>(
        create: (context) => _viewModel,
        child: Consumer<T>(
            builder: (context, provider, child){
              return this.childWidget(provider);
            }
        )
    );
  }

}