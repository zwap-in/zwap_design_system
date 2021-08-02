# zwap_design_system

The Zwap design system kit

## General Info

This repository is a simple package to get the base design asset system kit for any flutter projects with the graphic like zwap.in

## Structure 

 - [Base folder](lib/base)
 
    - [media](lib/base/media/media.dart)
        - [ZwapAsset](lib/base/media/asset/zwapAsset.dart): component to render a custom image from local path or network path with zwap style
        - [ZwapIcon](lib/base/media/icon/zwapIcon.dart): component to render a custom icon with zwap style
        
    - [avatar](lib/base/avatar)
        - [ZwapAvatar](lib/base/avatar/zwapAvatar.dart): component to render a custom avatar component with Zwap style
        
    - [buttons](lib/base/buttons)
        - [ZwapButton](lib/base/buttons/classic/zwapButton.dart): component to render a zwap button with different predefined type of styles
    
    - [card](lib/base/card)
        - [ZwapCard](lib/base/card/zwapCard.dart): component to render a card with zwap predefined style
    
    - [checkBoxes](lib/base/checkBoxes/checkBoxes.dart)
        - [ZwapTodoCheck](lib/base/checkBoxes/icon/zwapTodoCheck.dart): Custom widget to render a TODO checkbox
        - [ZwapClassicCheckBox](lib/base/checkBoxes/classic/zwapClassicCheckBox.dart): Custom widget to render a custom checkbox
    
    - [customExpansion](lib/base/customExpansion)
        - [ZwapCustomExpansionTile](lib/base/customExpansion/zwapExpansion.dart): Custom widget to display an expansion widget with elements inside that and as heading component

    - [dropdown](lib/base/dropDowns/dropdowns.dart)
        - [ZwapCustomDropDown](lib/base/dropDowns/dropdowns.dart): component to render a zwap dropdown component with the zwap style
        
 
    - [text](lib/base/text)
        - [baseText](lib/base/text/text.dart): Component to render text with predefined font, and different styles in base of the type based as param
        
    - [switch](lib/base/switch)
    
        - [CustomSwitch](lib/base/switch/switch.dart): Custom switch component with predefined style
        
    - [progress](lib/base/progress/progress.dart)
    
        - [LinearPercentIndicator](lib/base/progress/linear/linear.dart): Custom component to render a linear progress bar component
        - [CircularPercentIndicator](lib/base/progress/circular/circular.dart): Custom component to render a circular progress bar component
        
    - [loading](lib/base/loadingSpinner)
    
        - [LoadingSpinner](lib/base/loadingSpinner/loadingSpinner.dart): Custom loader component
        
    - [layouts](lib/base/layouts/layouts.dart)
    
        - [horizontalScroll](lib/base/layouts/horizontalScroll/horizontalScroll.dart): Custom component to render an horizontal scroll
        - [verticalScroll](lib/base/layouts/verticalScroll/verticalScroll.dart): Custom component to render an vertical scroll
        - [infiniteScroll](lib/base/layouts/infiniteScroll/infiniteScroll.dart): Custom component to render an infinite scroll
        
    - [labelWidget](lib/base/labelWidget)
        
        - [labelWidget](lib/base/labelWidget/labelWidget.dart): Custom component to render a widget with a label on Top
    
    - [inputs](lib/base/inputs/inputs.dart)
         
        - [inputTag](lib/base/inputs/inputTag/inputTag.dart): Custom component to show input suggestion with value inside a dynamic row as tag elements
        - [classic](lib/base/inputs/classic/input): Classic input component with predefined style
   
    
    - [theme](lib/base/theme/theme.dart)
       - [colors](lib/base/theme/colors.dart): Zwap colors
       - [constants](lib/base/theme/constants.dart): Zwap constants value
    
  - [basicScreen folder](lib/basicScreens)
    
    - [notFound](lib/basicScreens/notFound/notFound.dart): default not found object screen
    - [notSupportedScreen](lib/basicScreens/notSupportedScreen/notSupportedScreen.dart): default not supported device screen
    - [splashComponent](lib/basicScreens/splashComponent): default splashComponent screen