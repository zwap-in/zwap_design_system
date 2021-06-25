import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zwap_design_system/base/base.dart';

class ScheduledCard extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return CustomCard(
        childComponent: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: BaseText(
                  texts: ["I tuoi meeting in programma"],
                  baseTextsType: [BaseTextType.title],
                  textsColor: [DesignColors.pinkyPrimary],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: BaseText(
                  texts: ["Visualizza tutti i tuoi meeting programmati. "
                      "Se hai necessità, riprogramma o cancella la partecipazione fino a 24h prima dal match"],
                  baseTextsType: [BaseTextType.subTitle],
                  textsColor: [DesignColors.greyPrimary],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: BaseText(
                          texts: ['Martedi, 8 Giugno 2021 ', 'Oggi'],
                          baseTextsType: [BaseTextType.normal, BaseTextType.normalBold]
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Flexible(
                              child: CustomCheckbox(isDone: true,)
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: BaseText(
                                texts: ["13:00 - 13:30 - Federico <> Luigi"],
                                baseTextsType: [BaseTextType.normal],
                              ),
                            ),
                            flex: 2,
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),

                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            flex: 2,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Flexible(
                              child: CustomCheckbox(isDone: true,)
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: BaseText(
                                texts: ["13:00 - 13:30 - Federico <> Luigi"],
                                baseTextsType: [BaseTextType.normal],
                              ),
                            ),
                            flex: 2,
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),

                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            flex: 2,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Flexible(
                              child: CustomCheckbox(isDone: true,)
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: BaseText(
                                texts: ["13:00 - 13:30 - Federico <> Luigi"],
                                baseTextsType: [BaseTextType.normal],
                              ),
                            ),
                            flex: 2,
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),

                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            flex: 2,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Flexible(
                              child: CustomCheckbox(isDone: true,)
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: BaseText(
                                texts: ["13:00 - 13:30 - Federico <> Luigi"],
                                baseTextsType: [BaseTextType.normal],
                              ),
                            ),
                            flex: 2,
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),

                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            flex: 2,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: BaseText(
                          texts: ['Martedi, 8 Giugno 2021 ', 'Oggi'],
                          baseTextsType: [BaseTextType.normal, BaseTextType.normalBold]
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Flexible(
                              child: CustomCheckbox(isDone: true,)
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: BaseText(
                                texts: ["13:00 - 13:30 - Federico <> Luigi"],
                                baseTextsType: [BaseTextType.normal],
                              ),
                            ),
                            flex: 2,
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),

                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            flex: 2,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Flexible(
                              child: CustomCheckbox(isDone: true,)
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: BaseText(
                                texts: ["13:00 - 13:30 - Federico <> Luigi"],
                                baseTextsType: [BaseTextType.normal],
                              ),
                            ),
                            flex: 2,
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),

                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            flex: 2,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Flexible(
                              child: CustomCheckbox(isDone: true,)
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: BaseText(
                                texts: ["13:00 - 13:30 - Federico <> Luigi"],
                                baseTextsType: [BaseTextType.normal],
                              ),
                            ),
                            flex: 2,
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),

                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            flex: 2,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Flexible(
                              child: CustomCheckbox(isDone: true,)
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: BaseText(
                                texts: ["13:00 - 13:30 - Federico <> Luigi"],
                                baseTextsType: [BaseTextType.normal],
                              ),
                            ),
                            flex: 2,
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),

                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            flex: 2,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: BaseText(
                          texts: ['Martedi, 8 Giugno 2021 ', 'Oggi'],
                          baseTextsType: [BaseTextType.normal, BaseTextType.normalBold]
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Flexible(
                              child: CustomCheckbox(isDone: true,)
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: BaseText(
                                texts: ["13:00 - 13:30 - Federico <> Luigi"],
                                baseTextsType: [BaseTextType.normal],
                              ),
                            ),
                            flex: 2,
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),

                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            flex: 2,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Flexible(
                              child: CustomCheckbox(isDone: true,)
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: BaseText(
                                texts: ["13:00 - 13:30 - Federico <> Luigi"],
                                baseTextsType: [BaseTextType.normal],
                              ),
                            ),
                            flex: 2,
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),

                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            flex: 2,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Flexible(
                              child: CustomCheckbox(isDone: true,)
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: BaseText(
                                texts: ["13:00 - 13:30 - Federico <> Luigi"],
                                baseTextsType: [BaseTextType.normal],
                              ),
                            ),
                            flex: 2,
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),

                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            flex: 2,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Flexible(
                              child: CustomCheckbox(isDone: true,)
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: BaseText(
                                texts: ["13:00 - 13:30 - Federico <> Luigi"],
                                baseTextsType: [BaseTextType.normal],
                              ),
                            ),
                            flex: 2,
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),

                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: BaseButton(
                                      iconButton: FontAwesomeIcons.trash,
                                      buttonText: "Cancella",
                                      buttonTypeStyle: ButtonTypeStyle.greyButton,
                                      onPressedCallback: (){},
                                      iconColor: DesignColors.blackPrimary,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            flex: 2,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

}