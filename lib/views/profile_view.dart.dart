import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator_app/widgets/profile_text_field.dart';
import 'package:translator_app/widgets/profile_buttons.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String? _gender;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('name') ?? '';
    _emailController.text = prefs.getString('email') ?? '';
    _phoneController.text = prefs.getString('phone') ?? '';
    _gender = prefs.getString('gender');
    String? savedImagePath = prefs.getString('imagePath');

    if (savedImagePath != null) {
      setState(() {
        _selectedImage = File(savedImagePath);
      });
    }
  }

  _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', _nameController.text);
    prefs.setString('email', _emailController.text);
    prefs.setString('phone', _phoneController.text);
    prefs.setString('gender', _gender ?? '');
    if (_selectedImage != null) {
      prefs.setString('imagePath', _selectedImage!.path);
    }
  }

  _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  _resetProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('phone');
    await prefs.remove('gender');
    await prefs.remove('imagePath');

    setState(() {
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _gender = null;
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff3375FD),
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : AssetImage('assets/person.png') as ImageProvider,
                  child: _selectedImage == null
                      ? Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              SizedBox(height: 16),
              ProfileTextField(
                controller: _nameController,
                label: 'Enter your name',
              ),
              SizedBox(height: 16),
              ProfileTextField(
                controller: _emailController,
                label: 'Enter your email',
              ),
              SizedBox(height: 16),
              ProfileTextField(
                controller: _phoneController,
                label: 'Enter your phone number',
              ),
              SizedBox(height: 30),
              ProfileButtons(
                OnPressedProfile: _saveProfile,
                btnText: 'Save Profile',
                backgroundColor: Colors.green,
                snackBarContent: 'Profile saved successfully!',
              ),
              SizedBox(height: 16),
              ProfileButtons(
                OnPressedProfile: _resetProfile,
                backgroundColor: Colors.red,
                btnText: 'Reset Profile',
                snackBarContent: 'Profile reset successfully!',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
