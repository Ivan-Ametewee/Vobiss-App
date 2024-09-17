import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerScreen extends StatefulWidget {
  static const String id = 'image_picker';

  const ImagePickerScreen({super.key});
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  final ImagePicker _picker = ImagePicker();

  // Function to request permissions and pick an image or video
  Future<void> _pickMedia({required bool isVideo}) async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.accessMediaLocation.request();
    }

    XFile? pickedFile;
    if (isVideo) {
      // Pick a video
      pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    } else {
      // Pick an image
      pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    }

    if (pickedFile != null) {
      // Return the picked media (image or video) to the previous screen
      Navigator.pop(context, pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Media'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _pickMedia(isVideo: false),
              child: const Text('Select Image from Gallery'),
            ),
            ElevatedButton(
              onPressed: () => _pickMedia(isVideo: true),
              child: const Text('Select Video from Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
