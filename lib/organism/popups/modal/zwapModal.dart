/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/molecules.dart';

import '../../cards/cards.dart';

/// Edit profile popup component
class ZwapModal extends StatelessWidget {

  /// The card title
  final String cardTitle;

  /// The custom callBack function on close icon click
  final Function() closeButtonCallBack;

  /// THe child component inside this popup
  final Widget childComponent;

  /// The primary button text
  final String primaryButtonText;

  /// The custom callBack function on primary button click
  final Function() primaryButtonCallBack;

  final int containerHeight;

  /// Flag to check if this popup card has a back button
  final bool hasBackButton;

  /// The iconData about the back button icon
  final IconData iconBackButton;

  /// Custom CallBack function to handle optionally the back button if it's present
  final Function()? backButtonCallBack;

  /// Optionally secondary button text
  final String? secondaryButtonText;

  /// The custom callBack function on secondary button click
  final Function()? secondaryButtonCallBack;

  ZwapModal(
      {Key? key,
      required this.cardTitle,
      required this.closeButtonCallBack,
      required this.childComponent,
      required this.primaryButtonText,
      required this.primaryButtonCallBack,
      required this.containerHeight,
      this.hasBackButton = false,
      this.iconBackButton = Icons.arrow_back,
      this.backButtonCallBack,
      this.secondaryButtonText, this.secondaryButtonCallBack
      })
      : super(key: key) {
    if (this.secondaryButtonText == null) {
      assert(this.secondaryButtonCallBack == null,
          "Secondary button click callBack must be null on secondary button text null");
    } else {
      assert(this.secondaryButtonCallBack != null,
          "Secondary button click callBack must be not equal to none");
    }
    if (this.hasBackButton) {
      assert(this.backButtonCallBack != null,
          "If has back button is true backButtonCallBack must be not null");
    } else {
      assert(this.backButtonCallBack == null,
          "If has back button is false backButtonCallBack must be null");
    }
  }

  /// It retrieves the title section for this popup
  Widget _getTitleSection() {
    List<Widget> children = [];
    if (this.hasBackButton) {
      children.add(
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: InkWell(
                  onTap: () => this.backButtonCallBack!(),
                  child: Icon(
                    this.iconBackButton,
                    color: ZwapColors.shades100,
                    size: 32,
                  ),
                ),
                flex: 0,
                fit: FlexFit.tight,
              )
            ],
          ),
          flex: 0,
          fit: FlexFit.tight,
        ),
      );
    }
    children.addAll([
      Expanded(
        child: Center(
          child: ZwapText(
            text: this.cardTitle,
            textColor: ZwapColors.neutral700,
            zwapTextType: ZwapTextType.h3,
          ),
        ),
      ),
      Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: InkWell(
                onTap: () => this.closeButtonCallBack(),
                child: Icon(
                  Icons.close,
                  color: ZwapColors.shades100,
                  size: 32,
                ),
              ),
              flex: 0,
              fit: FlexFit.tight,
            )
          ],
        ),
        flex: 0,
        fit: FlexFit.tight,
      )
    ]);
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: children,
      ),
    );
  }

  /// It retrieves the bottom buttons section
  Widget _getBottomButtonsSection() {
    Widget primaryButton = ZwapButton(
      zwapButtonType: ZwapButtonType.primary,
      zwapButtonStatus: ZwapButtonStatus.defaultStatus,
      zwapButtonContentType: ZwapButtonContentType.noIcon,
      onPressedCallBack: () => this.primaryButtonCallBack(),
      text: this.primaryButtonText,
    );
    return this.secondaryButtonText != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              primaryButton,
              ZwapButton(
                zwapButtonType: ZwapButtonType.flat,
                zwapButtonStatus: ZwapButtonStatus.defaultStatus,
                zwapButtonContentType: ZwapButtonContentType.noIcon,
                onPressedCallBack: () => this.secondaryButtonCallBack!(),
                text: this.secondaryButtonText,
              )
            ],
          )
        : primaryButton;
  }

  @override
  Widget build(BuildContext context) {
    return ZwapCard(
      child: ZwapVerticalScroll(
        child:Column(
          children: [
            this._getTitleSection(),
            Divider(
              color: ZwapColors.neutral200,
              thickness: 1,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Flexible(
                    child: SizedBox(
                      height: this.containerHeight.toDouble(),
                      child: ZwapVerticalScroll(
                        child: this.childComponent,
                      ),
                    ),
                    fit: FlexFit.tight,
                    flex: 0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: this._getBottomButtonsSection(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      zwapCardType: ZwapCardType.levelOne,
    );
  }
}
