/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taastrap/taastrap.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';


/// The main function to start the application
main() async{
  runApp(MyApp());
}

/// Handle the app state with a custom provider
class MyApp extends StatefulWidget{

  _MyAppState createState() => _MyAppState();

}

/// The application starter point
class _MyAppState extends State<MyApp> {

  late Future<bool> _future;

  initState() {
    super.initState();
    _future = this.getSimpleData();
  }

  ApiService apiService = ApiService(baseUrl: "http://127.0.0.1:8080", headerAuthKey: "");

  Future<bool> getSimpleData() async{
    await apiService.get("", null, null);
    return true;
  }

  List<IconData> iconsCodePoint(){
    return [
      Icons.home,
      Icons.message,
      Icons.notification_important
    ];
  }

  List<ZwapBottomIconMenu> getBottomIcon(BuildContext context){
    List<ZwapBottomIconMenu> icons = [];
    this.iconsCodePoint().asMap().forEach((int key, IconData value) {
      icons.add(
        ZwapBottomIconMenu(
            isSelected: context.read<ZwapBottomMenuState>().currentIndex == key,
            iconData: value
        )
      );
    });
    return icons;
  }

  Widget plotMainColumn(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: ZwapVerticalScroll(
        childComponent: ZwapCard(
          childComponent: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                ZwapPickerImage(textLabel: "Change pic"),
                ZwapCalendarPicker(handleKeyName: (String key) => key,),
                Padding(
                  padding: EdgeInsets.all(10),
                  child:  ZwapButton(
                    buttonText: "Continue button",
                    buttonTypeStyle: ZwapButtonType.continueButton,
                    onPressedCallback: () => ZwapToast.show("Continue toast"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ZwapButton(
                    buttonText: "Grey button",
                    buttonTypeStyle: ZwapButtonType.greyButton,
                    onPressedCallback: () => ZwapToast.show("Grey toast"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ZwapButton(
                    buttonText: "Pinky button",
                    buttonTypeStyle: ZwapButtonType.pinkyButton,
                    onPressedCallback: () => ZwapToast.show("Pinky toast"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ZwapButton(
                    buttonText: "Social Google button",
                    buttonTypeStyle: ZwapButtonType.socialButtonGoogle,
                    onPressedCallback: () => ZwapToast.show("Social Google toast"),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: ZwapRowButtons(
                        leftLabelText: "left",
                        rightLabelText: "right"
                    )
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: ZwapBottomButtons(
                      continueButtonText: 'Continue',
                      continueButtonCallBackFunction: () => ZwapToast.show("Continue button"),
                      backButtonCallBackFunction: () => ZwapToast.show("Back button"),
                      backButtonText: "back",
                    )
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: ZwapSwitch()
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: ZwapTag(
                      tagText: "tag",
                      icon: Icons.delete,
                      callBackClick: () => ZwapToast.show("Delete tag"),
                      tagStyleType: ZwapTagStyle.pinkyTag,
                    )
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: ZwapTag(
                      tagText: "tag",
                      icon: Icons.delete,
                      callBackClick: () => ZwapToast.show("Delete tag"),
                      tagStyleType: ZwapTagStyle.blueTag,
                    )
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ZwapExpansion(
                    title: ZwapText(
                      texts: ["Test"],
                      baseTextsType: [ZwapTextType.title],
                    ),
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child:  ZwapClassicCheckBox(
                                labelText: ZwapText(
                                  texts: [
                                    "Classic checkbox"
                                  ],
                                  baseTextsType: [ZwapTextType.normalBold],
                                )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: ZwapTodoCheck(isDone: false,),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: ZwapTodoCheck(isDone: true,),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget desktopSuccessLayout(){
    return Row(
      children: [
        Flexible(
            child: ZwapLateralMenu(
                getCorrectText: (String key) => key,
                listMenu: [
                  "First item success",
                  "Second item success",
                  "Third item success"
                ]
            ),
          flex: 0,
        ),
        Expanded(
            child: this.plotMainColumn()
        ),
      ],
    );
  }

  Widget errorLayout(){
    return ZwapText(
      texts: ["Error"],
      baseTextsType: [ZwapTextType.normal],
    );
  }

  Widget handleSuccessWidget(){
    int deviceType = Utils.getIt<Generic>().deviceType();
    return deviceType > 2 ? this.desktopSuccessLayout() : this.plotMainColumn();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiProvider(
        child: LayoutBuilder(builder: (context, size){
          Generic deviceType = Generic(maxWith: size.maxWidth.toInt());
          if(Utils.getIt.isRegistered<Generic>()){
            Utils.getIt.unregister<Generic>();
          }
          Utils.getIt.registerSingleton<Generic>(deviceType);
          return Scaffold(
            appBar: ZwapAppBar(
                child: Row(
                  children: [
                    ZwapAvatar(imagePath: "", isInternal: true,)
                  ],
                )
            ),
            bottomNavigationBar: deviceType.deviceType() < 3 ? ZwapBottomMenu(
                bottomNavigationBarItems: this.getBottomIcon(context)
            ) : null,
            body: ZwapFuture<bool>(
              future: _future,
              builder: (bool value) => Container(
                child: value ? this.handleSuccessWidget() : this.errorLayout(),
              ),
            ),
          );
        }),
        providers: [
          ChangeNotifierProvider<ZwapBottomMenuState>(
              create: (_) => ZwapBottomMenuState()
          ),
          ChangeNotifierProvider<ZwapLateralMenuState>(
              create: (_) => ZwapLateralMenuState(
                  changeCallBack: (String newIndex) => {},
                  current: "First item success"
              )
          ),
          ChangeNotifierProvider<ZwapImagePickerState>(
            create: (_) => ZwapImagePickerState(),
          ),
          ChangeNotifierProvider<ZwapRowButtonsState>(
              create: (_) => ZwapRowButtonsState(selected: 0)
          ),
          ChangeNotifierProvider<ZwapSwitchState>(
            create: (_) => ZwapSwitchState(value: false),
          ),
          ChangeNotifierProvider<ZwapClassicCheckBoxState>(
            create: (_) => ZwapClassicCheckBoxState(value: false),
          ),
          ChangeNotifierProvider<ZwapCalendarPickerState>(
              create: (_) => ZwapCalendarPickerState(
                  dateEnd: DateTime(2021, 8, 31),
                  slotsPerDay: {
                    1: [
                      TimeOfDay(hour: 13, minute: 0),
                      TimeOfDay(hour: 17, minute: 0),
                      TimeOfDay(hour: 19, minute: 0),
                      TimeOfDay(hour: 22, minute: 0),
                    ],
                    2: [
                      TimeOfDay(hour: 13, minute: 0),
                      TimeOfDay(hour: 17, minute: 0),
                      TimeOfDay(hour: 19, minute: 0),
                      TimeOfDay(hour: 22, minute: 0),
                    ],
                    3: [
                      TimeOfDay(hour: 13, minute: 0),
                      TimeOfDay(hour: 17, minute: 0),
                      TimeOfDay(hour: 19, minute: 0),
                      TimeOfDay(hour: 22, minute: 0),
                    ],
                    4: [
                      TimeOfDay(hour: 13, minute: 0),
                      TimeOfDay(hour: 17, minute: 0),
                      TimeOfDay(hour: 19, minute: 0),
                      TimeOfDay(hour: 22, minute: 0),
                    ],
                    5: [
                      TimeOfDay(hour: 13, minute: 0),
                      TimeOfDay(hour: 17, minute: 0),
                      TimeOfDay(hour: 19, minute: 0),
                      TimeOfDay(hour: 22, minute: 0),
                    ]
                  }, 
                  selectedDates: Set(), 
                  maxSelections: 4
              )
          )
        ],
      ),
    );
  }
}


