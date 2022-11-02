import 'package:diaree/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import '../../constants/color.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/route_manager.dart';
import '../../resources/values_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // navigate to settings
    void navigateToSettings() {
      Navigator.of(context).pushNamed(RouteManager.settingsScreen);
    }

    // search fnc
    void searchFnc() {
      //Todo: Implement search
    }

    // navigate to create new note
    void navigateToCreateNewNote() {
      Navigator.of(context)
          .pushNamed(RouteManager.createNoteScreen)
          .then((value) => Navigator.of(context).pop());
    }

    // navigate to edit screen
    void createNew() {
      Navigator.of(context).pushNamed(RouteManager.createNoteScreen);
    }

    // view entry
    void viewEntry() {
      // Todo: Implement view Entry
      Navigator.of(context)
          .pushNamed(RouteManager.viewNoteScreen)
          .then((value) => Navigator.of(context).pop());
    }

    // delete entry
    void deleteEntry() {
      // Todo: Implement delete entry
    }

    // edit entry
    void editEntry() {
      // Todo: Implement edit entry
      Navigator.of(context)
          .pushNamed(RouteManager.editNoteScreen)
          .then((value) => Navigator.of(context).pop());
    }

    // show options
    void showOptions() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => viewEntry(),
                icon: const Icon(
                  Icons.visibility,
                  color: Colors.black,
                  size: AppSize.s25,
                ),
                label: Text(
                  'View Entry',
                  style: getRegularStyle(
                    color: Colors.black,
                    fontWeight: FontWeightManager.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => editEntry(),
                icon: const Icon(
                  Icons.edit,
                  color: Colors.black,
                  size: AppSize.s25,
                ),
                label: Text(
                  'Edit Entry',
                  style: getRegularStyle(
                    color: Colors.black,
                    fontWeight: FontWeightManager.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => deleteEntry(),
                icon: const Icon(
                  Icons.delete,
                  color: primaryColor,
                  size: AppSize.s25,
                ),
                label: Text(
                  'Delete Entry',
                  style: getRegularStyle(
                    color: primaryColor,
                    fontWeight: FontWeightManager.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => createNew(),
        child: const Icon(
          Icons.edit,
          color: Colors.white,
          size: AppSize.s35,
        ),
      ),
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () => createNew(),
        //   icon: const Icon(
        //     Icons.edit,
        //   ),
        // ),
        actions: [
          IconButton(
            onPressed: () => navigateToSettings(),
            icon: const Icon(Icons.settings),
          )
        ],
        centerTitle: true,
        title: Image.asset(
          AssetManager.logo,
          color: Colors.black,
          width: 110,
        ),
      ),
      backgroundColor: backgroundLite,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 13),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                hintText: 'Search entries',
                hintStyle: TextStyle(
                  color: greyShade2,
                  fontSize: FontSize.s14,
                  fontWeight: FontWeightManager.medium,
                ),
                suffixIcon: IconButton(
                  onPressed: () => searchFnc(),
                  icon: Icon(
                    Icons.search,
                    color: greyShade2,
                    size: AppSize.s30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSize.s20),
            Expanded(
                // height:300,
                child: ListView(
              children: List.generate(
                99,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: SizedBox(
                    height: size.height * 0.15,
                    child: GestureDetector(
                      onTap: () => showOptions(),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Summer Vacation!',
                                    style: getBoldStyle(
                                        color: Colors.black,
                                        fontSize: FontSize.s16),
                                  ),
                                  SizedBox(
                                    width: size.width / 1.55,
                                    child: Text(
                                      'Today, my summer holidays have begun. I have some plans for sum...',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.justify,
                                      style: getRegularStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '17th April 2002',
                                    style: getRegularStyle(
                                      color: greyShade2,
                                      fontWeight: FontWeightManager.medium,
                                      fontSize: FontSize.s12,
                                    ),
                                  ),
                                ],
                              ),
                              Image.asset(AssetManager.happy)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
