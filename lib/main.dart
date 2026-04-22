import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Counter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;
  File? imageFile;

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile =
        await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void increase() {
    setState(() {
      count++;
    });
  }

  void decrease() {
    setState(() {
      if (count > 0) count--;
    });
  }

  void reset() {
    setState(() {
      count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter App"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageFile != null
                  ? CircleAvatar(
                      radius: 60,
                      backgroundImage: FileImage(imageFile!),
                    )
                  : const CircleAvatar(
                      radius: 60,
                      child: Icon(Icons.person, size: 60),
                    ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => pickImage(ImageSource.gallery),
                child: const Text("Pick from Gallery"),
              ),

              ElevatedButton(
                onPressed: () => pickImage(ImageSource.camera),
                child: const Text("Open Camera"),
              ),

              const SizedBox(height: 30),

              Text(
                "$count",
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: decrease,
                    child: const Text("-"),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: increase,
                    child: const Text("+"),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: reset,
                child: const Text("Reset"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
