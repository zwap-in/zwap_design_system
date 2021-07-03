/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:taastrap/colStrap/colStrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The state of the bio
class CompleteBioState extends ChangeNotifier{

  /// The bio in input
  String bio = "";

  /// Changing the bio with the state handler
  void changeBio(String value){
    this.bio = value;
    notifyListeners();
  }

}


/// The complete bio component
class CompleteBio extends StatelessWidget{

  /// The back button callBack function
  final Function() backButtonCallBack;

  /// The continue button callBack function
  final Function() continueButtonCallBack;

  /// The bio regex to validate the input in bio
  final String bioRegex;

  CompleteBio({Key? key,
    required this.backButtonCallBack,
    required this.continueButtonCallBack,
    required this.bioRegex,
  }): super(key: key);

  /// Validate any bio input
  bool validateBio(String text){
    return Utils.validateRegex(this.bioRegex, text);
  }

  /// It retrieves some examples for bio
  Map<Widget, Map<String, int>> exampleBio(BuildContext context){
    Map<Widget, Map<String, int>> finals = {};
    User tmpOne = User(
      lastName: "Rossi",
      firstName: "Marco",
      profileBio: Utils.getIt<LocalizationClass>().dynamicValue("bioExampleOne"),
      targetsData: [],
      interests: [],
      customData: {
        'role': 'CEO',
        'company': 'ZWAP'
      },
      pk: 1
    );
    User tmpTwo = User(
        lastName: "Rossi",
        firstName: "Marco",
        profileBio: Utils.getIt<LocalizationClass>().dynamicValue("bioExampleOne"),
        targetsData: [],
        interests: [],
        customData: {
          'role': 'CEO',
          'company': 'ZWAP'
        },
        pk: 1
    );
    User tmpThree = User(
        lastName: "Rossi",
        firstName: "Marco",
        profileBio: Utils.getIt<LocalizationClass>().dynamicValue("bioExampleOne"),
        targetsData: [],
        interests: [],
        customData: {
          'role': 'CEO',
          'company': 'ZWAP'
        },
        pk: 1
    );
    Map<String, int> tmpMapping = {'xl': 4, 'lg': 4, 'md': 4, 'sm': 12, 'xs': 12};
    Widget sneakOne = SneakUser(userInfo: tmpOne, saveUser: null, viewProfile: null);
    Widget sneakTwo = SneakUser(userInfo: tmpTwo, saveUser: null, viewProfile: null);
    Widget sneakThree = SneakUser(userInfo: tmpThree, saveUser: null, viewProfile: null);
    finals[sneakOne] = tmpMapping;
    finals[sneakTwo] = tmpMapping;
    finals[sneakThree] = tmpMapping;
    return finals;
  }

  @override
  Widget build(BuildContext context) {
    CompleteBioState instance = CompleteBioState();
    Utils.registerType<CompleteBioState>(instance);
    return BaseComplete(
        childrenWidget: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: BaseText(
              texts: [Utils.getIt<LocalizationClass>().dynamicValue("bioCompleteTitle")],
              baseTextsType: [BaseTextType.title],
              textsColor: [DesignColors.pinkyPrimary],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: BaseText(
              texts: [Utils.getIt<LocalizationClass>().dynamicValue("bioCompleteSubTitle")],
              baseTextsType: [BaseTextType.subTitle],
              textsColor: [DesignColors.greyPrimary],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                ProviderCustomer<CompleteBioState>(
                  childWidget: (CompleteBioState provider){
                    return BaseInput(
                      inputType: InputType.inputArea,
                      maxLines: 5,
                      placeholderText: '',
                      validateValue: (value) => true,
                      changeValue: (value) => provider.changeBio(value),
                    );
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    BaseText(
                      texts: [Utils.getIt<LocalizationClass>().dynamicValue("minBioInput")],
                      baseTextsType: [BaseTextType.normalBold],
                      textsColor: [DesignColors.pinkyPrimary],
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: BaseText(
              texts: [Utils.getIt<LocalizationClass>().dynamicValue("bioExampleTitle")],
              baseTextsType: [BaseTextType.title],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ResponsiveRow(
              children: this.exampleBio(context),
            ),
          ),
        ],
        backButtonCallBack: () => this.backButtonCallBack(),
        continueButtonCallBack: () => this.continueButtonCallBack()
    );
  }
}