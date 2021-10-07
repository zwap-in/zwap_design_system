/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

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

  /// The modal container height
  final int containerHeight;

  /// Flag to check if this popup card has a back button
  final bool hasBackButton;

  /// The iconData about the back button icon
  final IconData iconBackButton;

  /// The primary button text
  final String? primaryButtonText;

  /// The custom callBack function on primary button click
  final Function()? primaryButtonCallBack;

  /// Custom CallBack function to handle optionally the back button if it's present
  final Function()? backButtonCallBack;

  /// Optionally secondary button text
  final String? secondaryButtonText;

  /// The custom callBack function on secondary button click
  final Function()? secondaryButtonCallBack;

  /// The modal container width
  final double? containerWidth;

  /// The optionally modal image to display inside the invite popup modal
  final Image? modalImage;

  ZwapModal(
      {Key? key,
        required this.cardTitle,
        required this.closeButtonCallBack,
        required this.childComponent,
        required this.containerHeight,
        this.containerWidth,
        this.hasBackButton = false,
        this.iconBackButton = Icons.arrow_back,
        this.backButtonCallBack,
        this.primaryButtonText,
        this.primaryButtonCallBack,
        this.secondaryButtonText, this.secondaryButtonCallBack,
        this.modalImage
      })
      : super(key: key) {
    if(this.primaryButtonText == null){
      assert(this.primaryButtonCallBack == null,
      "Primary button click callBack must be null on primary button text null");
    }
    else {
      assert(this.primaryButtonCallBack != null,
      "Primary button click callBack must be not equal to none");
    }
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
            mainAxisAlignment: MainAxisAlignment.center,
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
            zwapTextType: ZwapTextType.h4,
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
                  ZwapIcons.icons['close']!,
                  color: ZwapColors.neutral400,
                  size: 24,
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

  /// It gets the mobile bottom buttons inside the custom modal
  Widget _getMobileBottomButtons(Widget primaryButton){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        primaryButton,
        ZwapButton(
          zwapButtonType: ZwapButtonType.flat,
          zwapButtonStatus: ZwapButtonStatus.defaultStatus,
          zwapButtonContentType: ZwapButtonContentType.noIcon,
          onPressedCallBack: () => this.secondaryButtonCallBack!(),
          verticalPadding: 15,
          text: this.secondaryButtonText,
        )
      ],
    );
  }

  /// It gets the desktop bottom buttons inside the custom model
  Widget _getDesktopBottomButtons(Widget primaryButton){
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 5),
            child: ZwapButton(
              zwapButtonType: ZwapButtonType.flat,
              zwapButtonStatus: ZwapButtonStatus.defaultStatus,
              zwapButtonContentType: ZwapButtonContentType.noIcon,
              onPressedCallBack: () => this.secondaryButtonCallBack!(),
              verticalPadding: 15,
              text: this.secondaryButtonText,
              fullAxis: true,
            ),
          ),
          flex: 1,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 5),
            child: primaryButton,
          ),
          flex: 1,
        ),
      ],
    );
  }

  /// It retrieves the bottom buttons section
  Widget _getBottomButtonsSection() {
    Widget primaryButton = this.primaryButtonText != null && this.primaryButtonCallBack != null ? ZwapButton(
      fullAxis: true,
      zwapButtonType: ZwapButtonType.primary,
      zwapButtonStatus: ZwapButtonStatus.defaultStatus,
      zwapButtonContentType: ZwapButtonContentType.noIcon,
      onPressedCallBack: () => this.primaryButtonCallBack!(),
      text: this.primaryButtonText!,
      verticalPadding: 15,
    ) : Container();
    return this.secondaryButtonText != null
        ? getMultipleConditions(this._getDesktopBottomButtons(primaryButton),
        this._getDesktopBottomButtons(primaryButton), this._getMobileBottomButtons(primaryButton),
        this._getMobileBottomButtons(primaryButton),
        this._getMobileBottomButtons(primaryButton))
        : primaryButton;
  }

  @override
  Widget build(BuildContext context) {
    return ZwapCard(
      child: ZwapVerticalScroll(
        child:Column(
          children: [
            this._getTitleSection(),
            this.modalImage ?? Divider(
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
                      width: this.containerWidth,
                      child: ZwapVerticalScroll(
                        child: this.childComponent,
                      ),
                    ),
                    fit: FlexFit.tight,
                    flex: 0,
                  ),
                  this._getBottomButtonsSection()
                ],
              ),
            )
          ],
        ),
      ),
      cardWidth: this.containerWidth,
      zwapCardType: ZwapCardType.levelZero,
    );
  }
}
