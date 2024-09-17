import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class CameraScreen extends StatefulWidget {
  static const String id = 'camera_screen';
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _isUploading = false; // Track upload status

  Future<void> _takePictureOrVideo(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    // Ask the user whether to take a picture or record a video
    final action = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose media type'),
          actions: <Widget>[
            TextButton(
              child: const Text('Take Picture'),
              onPressed: () {
                Navigator.of(context).pop('image');
              },
            ),
            TextButton(
              child: const Text('Record Video'),
              onPressed: () {
                Navigator.of(context).pop('video');
              },
            ),
          ],
        );
      },
    );

    XFile? file;

    // Take picture or video based on user choice
    if (action == 'image') {
      file = await picker.pickImage(source: ImageSource.camera);
    } else if (action == 'video') {
      file = await picker.pickVideo(source: ImageSource.camera);
    }

    // If a file was captured, upload it
    if (file != null) {
      final isVideo = action == 'video';

      setState(() {
        _isUploading = true; // Show loader
      });

      // Upload file based on type
      await _uploadFile(file, isVideo: isVideo);

      setState(() {
        _isUploading = false; // Hide loader after upload
      });
    }
  }

  Future<void> _uploadFile(XFile file, {required bool isVideo}) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('uploads/${file.name}');
      File fileToUpload = File(file.path);

      // Upload the file (same for image or video)
      await storageRef.putFile(fileToUpload);

      // Get the download URL
      String downloadURL = await storageRef.getDownloadURL();
      print('Download URL: $downloadURL');

      // Return the download URL to the previous screen
      Navigator.pop(context, downloadURL);
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture and Upload Media'),
      ),
      body: Center(
        child: _isUploading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(), // Loader while uploading
                  const SizedBox(height: 20),
                  const Text('Uploading...'),
                ],
              )
            : ElevatedButton(
                onPressed: () => _takePictureOrVideo(context),
                child: const Text('Capture and Upload Media'),
              ),
      ),
    );
  }
}
