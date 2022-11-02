import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaree/components/loading.dart';
import 'package:diaree/resources/styles_manager.dart';
import 'package:diaree/screens/main/notes/edit.dart';
import 'package:diaree/screens/main/notes/view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/snackbar.dart';
import '../../constants/color.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/route_manager.dart';
import '../../resources/values_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseFirestore.instance;
    Stream<QuerySnapshot> notesStream =
        firebase.collection('notes').snapshots();

    Size size = MediaQuery.of(context).size;

    // navigate to settings
    void navigateToSettings() {
      Navigator.of(context).pushNamed(RouteManager.settingsScreen);
    }

    // search fnc
    void searchFnc() {
      //Todo: Implement search
    }

    // navigate to edit screen
    void createNew() {
      Navigator.of(context).pushNamed(RouteManager.createNoteScreen);
    }

    // view entry
    void viewEntry(DocumentSnapshot note) {
      // Todo: Implement view Entry
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) => ViewNoteScreen(note: note),
            ),
          )
          .then((value) => Navigator.of(context).pop());
    }

    // show dialog for delete
    void showDeleteOptions(DocumentSnapshot note) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Text('Do you want to delete ${note['title']}?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () {
                  firebase.collection('notes').doc(note.id).delete();
                  showSnackBar('Note deleted successfully!', context);
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.delete_forever,
                  color: primaryColor,
                  size: AppSize.s25,
                ),
                label: Text(
                  'Yes',
                  style: getRegularStyle(
                    color: primaryColor,
                    fontWeight: FontWeightManager.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.black,
                  size: AppSize.s25,
                ),
                label: Text(
                  'Cancel',
                  style: getRegularStyle(
                    color: Colors.black,
                    fontWeight: FontWeightManager.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // edit entry
    void editEntry(DocumentSnapshot note) {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) => EditNoteScreen(note: note),
            ),
          )
          .then((value) => Navigator.of(context).pop());
    }

    // show options
    void showOptions(DocumentSnapshot note) {
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
                onPressed: () => viewEntry(note),
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
                onPressed: () => editEntry(note),
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
                onPressed: () => showDeleteOptions(note),
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
              child: StreamBuilder<QuerySnapshot>(
                  stream: notesStream,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'An error occurred!',
                          style: getRegularStyle(
                            color: Colors.black,
                          ),
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Loading());
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AssetManager.empty),
                          Text(
                            'Notes are empty!',
                            style: getRegularStyle(
                              color: Colors.grey,
                            ),
                          )
                        ],
                      );
                    }

                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var note = snapshot.data!.docs[index];
                          var date = DateTime.fromMicrosecondsSinceEpoch(
                              note['date'].microsecondsSinceEpoch);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: SizedBox(
                              height: size.height * 0.15,
                              child: GestureDetector(
                                onTap: () => showOptions(note),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              note['title'],
                                              style: getBoldStyle(
                                                  color: Colors.black,
                                                  fontSize: FontSize.s16),
                                            ),
                                            SizedBox(
                                              width: size.width / 1.55,
                                              child: Text(
                                                note['content'],
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
                                              DateFormat.yMMMMEEEEd()
                                                  .format(date),
                                              style: getRegularStyle(
                                                color: greyShade2,
                                                fontWeight:
                                                    FontWeightManager.medium,
                                                fontSize: FontSize.s12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Image.asset(note['emotion'])
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            )
          ],
        ),
      ),
    );
  }
}

//
