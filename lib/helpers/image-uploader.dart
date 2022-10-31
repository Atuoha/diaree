import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../resources/assets_manager.dart';
import '../resources/font_manager.dart';
import '../resources/styles_manager.dart';

class ImageUploader extends StatefulWidget {
  const ImageUploader({
    Key? key,
    required this.imgUrl,
    required this.selectImageFnc,
    required this.isProfileImageEmpty,
  }) : super(key: key);
  final String imgUrl;
  final Function(File) selectImageFnc;
  final bool isProfileImageEmpty;

  @override
  State<ImageUploader> createState() => _ImageUploaderState();
}

// for photo selection
enum Source { camera, gallery }

class _ImageUploaderState extends State<ImageUploader> {
  final _picker = ImagePicker();
  XFile? profileImage;

  // for selecting photo
  Future _selectPhoto(Source source) async {
    XFile? pickedImage;
    switch (source) {
      case Source.camera:
        pickedImage = await _picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 100,
          maxHeight: 100,
        );
        break;
      case Source.gallery:
        pickedImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 100,
          maxHeight: 100,
        );
        break;
    }
    if (pickedImage == null) {
      return null;
    }

    // selectImageFnc for passing selecting image
    widget.selectImageFnc(File(pickedImage.path));

    // assign the picked image to the profileImage
    setState(() {
      profileImage = pickedImage;
    });
  }

  // imagePicker Dialog
  void _imagePickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                ),
                label: Text(
                  'Take Photo',
                  style: getMediumStyle(
                    color: Colors.black,
                    fontSize: FontSize.s16,
                  ),
                ),
                onPressed: () {
                  _selectPhoto(Source.camera);
                  Navigator.of(context).pop();
                },
              ),
              TextButton.icon(
                icon: const Icon(
                  Icons.photo,
                  color: Colors.black,
                ),
                label: Text(
                  'Choose From Gallery',
                  style: getMediumStyle(
                    color: Colors.black,
                    fontSize: FontSize.s16,
                  ),
                ),
                onPressed: () {
                  _selectPhoto(Source.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _imagePickerDialog(),
      child: CircleAvatar(
        // radius: profileImage == null ? 50 : 40,
        radius: 50,
        backgroundColor: Colors.white,
        child: Center(
          child: profileImage == null
              ? widget.isProfileImageEmpty
                  ? Image.asset(
                      AssetManager.avatarSmall,
                      fit: BoxFit.cover,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        widget.imgUrl,
                        fit: BoxFit.cover,
                      ),
                    ) // this will load imgUrl from firebase
              : ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.file(
                    File(
                      profileImage!.path,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }
}
