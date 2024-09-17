import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class UploadScreen extends StatefulWidget {
  static const String id = 'upload_screen';
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool _isUploading = false; // Track the upload status

  Future<void> _navigateAndPickImageOrVideo(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    // Ask the user whether to pick an image or a video
    final action = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose media type'),
          actions: <Widget>[
            TextButton(
              child: const Text('Pick Image'),
              onPressed: () {
                Navigator.of(context).pop('image');
              },
            ),
            TextButton(
              child: const Text('Pick Video'),
              onPressed: () {
                Navigator.of(context).pop('video');
              },
            ),
          ],
        );
      },
    );

    XFile? file;

    // Pick image or video based on user choice
    if (action == 'image') {
      file = await picker.pickImage(source: ImageSource.gallery);
    } else if (action == 'video') {
      file = await picker.pickVideo(source: ImageSource.gallery);
    }

    // If a file was selected, upload it
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
        title: const Text('Upload Media'),
      ),
      body: Center(
        child: _isUploading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(), // Loader while uploading
                  SizedBox(height: 20),
                  Text('Uploading...'),
                ],
              )
            : ElevatedButton(
                onPressed: () => _navigateAndPickImageOrVideo(context),
                child: const Text('Pick and Upload Media'),
              ),
      ),
    );
  }
}
