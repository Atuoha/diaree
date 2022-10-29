import 'package:diaree/constants/color.dart';
import 'package:diaree/resources/assets_manager.dart';
import 'package:diaree/resources/font_manager.dart';
import 'package:diaree/resources/styles_manager.dart';
import "package:flutter/material.dart";

import '../../../resources/route_manager.dart';
import '../../../resources/values_manager.dart';

class ViewNoteScreen extends StatelessWidget {
  const ViewNoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // navigate to edit screen
    void navigateToEdit() {
      // Todo: Implement edit
      Navigator.of(context)
          .pushNamed(RouteManager.editNoteScreen)
          .then((value) => Navigator.of(context).pop());
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => navigateToEdit(),
        child: const Icon(
          Icons.edit,
          color: Colors.white,
          size: AppSize.s35,
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            padding: const EdgeInsets.only(left: 18),
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        title: Text(
          'View Entry',
          style: getRegularStyle(
            color: Colors.black,
            fontWeight: FontWeightManager.medium,
            fontSize: FontSize.s18,
          ),
        ),
      ),
      backgroundColor: backgroundLite,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Summer\nVacation!',
                      style: getMediumStyle(
                        color: Colors.black,
                        fontSize: FontSize.s28,
                      ),
                    ),
                    Text(
                      '17th April 2002',
                      style: getRegularStyle(
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                Image.asset(AssetManager.happy)
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30,vertical:40,),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Text(
                "Today, my summer holidays have begun. I have some plans for summer vacation. I'm planning to go to a wildlife sanctuary and for boating in a lake. I just don't want to spend a single moment idly and definitely want to enjoy every bit of these holidays. \n\nLast year, I did not plan my vacations, but this year, I will do everything to make them interesting. I now need to go. I'm excited and eagerly looking forward to my holidays.",
                textAlign: TextAlign.justify,
                style: getRegularStyle(
                  color: Colors.black,
                  fontSize: FontSize.s16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
