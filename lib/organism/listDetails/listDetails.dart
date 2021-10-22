/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'providerState/providerState.dart';
import 'scrollCards/scrollCards.dart';

export 'providerState/providerState.dart';

/// The list details component with scroll cards and details component
class ListDetails<T> extends StatelessWidget{

  /// It gets the element with details about the selected item
  final Widget Function(T element) getDetailsElement;

  /// It gets the element inside the scroll cards
  final Widget Function(T element, bool isSelected) getScrollCard;

  ListDetails({Key? key,
    required this.getDetailsElement,
    required this.getScrollCard
  }): super(key: key);

  /// It builds the desktop view
  Widget _getDesktopView(ListDetailsProvideState<T> provider){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SizedBox(
            child: ScrollCards<T>(
              getCard: (T element, bool isSelected) => this.getScrollCard(element, isSelected),
            ),
            height: 600,
          ),
          flex: 2,
        ),
        Expanded(
          child: provider.getCurrentElement != null ? this.getDetailsElement(provider.getCurrentElement!) : Container(),
          flex: 3,
        )
      ],
    );
  }

  /// It builds the mobile view
  Widget _getMobileView(ListDetailsProvideState<T> provider){
    return Expanded(
      child: ScrollCards<T>(
        getCard: (T element, bool isSelected) => this.getScrollCard(element, isSelected),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ListDetailsProvideState<T>>(
        builder: (context, provider, child){
          return getMultipleConditions(this._getDesktopView(provider), this._getDesktopView(provider), this._getDesktopView(provider), this._getMobileView(provider), this._getMobileView(provider));
        }
    );
  }



}

