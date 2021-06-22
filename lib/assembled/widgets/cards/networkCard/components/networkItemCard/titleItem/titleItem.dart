/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

class TitleItem extends StatelessWidget{

  final String firstName;

  final String lastName;

  final String role;

  final String company;

  final String bioProfile;

  final int starsReview;

  final DateTime lastMeeting;

  TitleItem({Key? key,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.company,
    required this.bioProfile,
    required this.starsReview,
    required this.lastMeeting
  }): super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            child: Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: AvatarCircle(imagePath: ""),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        BaseText(
                          baseTextsType: [BaseTextType.title],
                          texts: ["${this.firstName} ${this.lastName}"],
                        ),
                        BaseText(
                          baseTextsType: [BaseTextType.normal],
                          texts: ["${this.role} @${this.company}"],
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: BaseText(
                      baseTextsType: [BaseTextType.normal],
                      texts: ["${this.bioProfile}"],
                    ),
                  ),
                ),
              ],
            ),
        ),
        Flexible(
          child: RatingBar.builder(
            initialRating: this.starsReview.toDouble(),
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemSize: 20,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
          flex: 0,
        ),
        Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: IconText(
                icon: Icons.timer,
                text: "Ultimo meeting - ${this.lastMeeting.day} ${this.lastMeeting.month} ${this.lastMeeting.year}",
              ),
            ),
          flex: 0,
        )

      ],
    );
  }

}